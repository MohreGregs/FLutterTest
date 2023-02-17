import 'package:flutter/material.dart';
import 'package:fluttertest/database/database.dart';
import 'package:fluttertest/database/entities/point.dart';

import '../classes/argument.dart';
import '../classes/diagramPainter.dart';
import '../database/entities/attribute.dart';
import '../database/entities/team.dart';

class DiagramPage extends StatefulWidget {
  const DiagramPage({super.key});

  @override
  State<StatefulWidget> createState() => DiagramState();
}

class DiagramState extends State<DiagramPage> {
  List<Team>? teams;
  List<Attribute>? attributes;
  Team? teamDropdownValue;
  List<Argument>? args;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Data"),
        ),
        body: Column(
          children: [
            DropdownButton(
                hint: const Text("Choose team..."),
                value: teamDropdownValue,
                icon: const Icon(Icons.account_circle_rounded),
                items: teams?.map<DropdownMenuItem<Team>>((Team team) {
                  return DropdownMenuItem<Team>(
                    value: team,
                    child: Text(team.name),
                  );
                }).toList(),
                onChanged: (Object? value) {
                  var team = value as Team;
                  setState(() {
                    teamDropdownValue = team;
                  });
                  getArgsOfTeam();
                }),
            (teamDropdownValue != null)
                ? (args != null && args!.isNotEmpty)
                    ? Expanded(
                        child: CustomPaint(
                            size: const Size(double.infinity, double.infinity),
                            painter: DiagramPainter(args!)),
                      )
                    : const Text("No data available")
                : const Text("Please select team")
          ],
        ));
  }

  void getArgsOfTeam() {
    AppDatabase.getPointsOfTeam(teamDropdownValue!.id).whenComplete(() => {
          setState(() {
            args = convertPoints(AppDatabase.pointsOfTeam);
          })
        });
  }

  List<Argument> convertPoints(List<Point>? points) {
    var args = <Argument>[];
    attributes?.forEach((attribute) {
      var arg = Argument(attribute.name, 0, -1, attribute.threshold,
          attribute.rangeStart, attribute.rangeEnd);
      var attributePoints = <double>[];
      points?.forEach((point) {
        if (point.attributeId == attribute.id) {
          attributePoints.add(point.value);
        }
      });
      if (attributePoints.length > arg.threshold) {
        var sum = 0.0;
        for (var element in attributePoints) {
          sum += element;
        }
        arg.value = ((sum / attributePoints.length) /
                (attribute.rangeEnd - attribute.rangeStart)) *
            100;
        args.add(arg);
      }
    });
    return args;
  }

  void fetchData() async{
    AppDatabase.getTeams().whenComplete(() => {
      setState(() {
        teams = AppDatabase.teams;
      })
    });
    AppDatabase.getAttributes().whenComplete(() => {
      setState(() {
        attributes = AppDatabase.attributes;
      })
    });
  }
}
