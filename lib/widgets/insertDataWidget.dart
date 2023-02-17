import 'package:flutter/material.dart';
import 'package:fluttertest/database/database.dart';
import 'package:fluttertest/database/entities/attribute.dart';
import 'package:fluttertest/database/entities/point.dart';
import 'package:fluttertest/widgets/sliderWithTextWidget.dart';

import '../classes/argument.dart';
import '../database/entities/team.dart';
import '../database/entities/user.dart';

class InsertDataPage extends StatefulWidget {
  const InsertDataPage({super.key});

  @override
  State<StatefulWidget> createState() => InsertDataPageState();
}

class InsertDataPageState extends State<InsertDataPage> {
  Team? teamDropdownValue;
  User? userDropdownValue;
  List<Argument>? attributes;
  List<Team>? teams;
  List<User>? teamUsers;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Insert Data"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/data');
                },
                icon: const Icon(Icons.bar_chart)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin').then((value) => {
                    fetchData()
                  });
                },
                icon: const Icon(Icons.accessible_forward_rounded))
          ],
        ),
        body: (teams != null && attributes != null)
            ? Column(
                children: <Widget>[
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
                        getTeamUsers(team.id);
                      }),
                  DropdownButton(
                      hint: const Text("Choose user..."),
                      value: userDropdownValue,
                      icon: const Icon(Icons.account_circle_rounded),
                      items:
                          teamUsers?.map<DropdownMenuItem<User>>((User user) {
                        return DropdownMenuItem<User>(
                          value: user,
                          child: Text(user.name),
                        );
                      }).toList(),
                      onChanged: (Object? value) {
                        setState(() {
                          userDropdownValue = value as User;
                        });
                      }),
                  getSliderWidgets(attributes),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      attributes?.forEach((element) {
                        AppDatabase.insertPoint(Point(-1, element.value, DateTime.now(), element.id, teamDropdownValue!.id, userDropdownValue!.id));
                      });
                      fetchData();
                    },
                    child: const Text('Send Data'),
                  ),
                ],
              )
            : const Center(
                child: Text("Please first insert teams, users and attributes"),
              ));
  }

  Widget getSliderWidgets(List<Argument>? attributes) {
    if (attributes != null) {
      if (attributes.isNotEmpty) {
        if(teamDropdownValue != null && userDropdownValue != null){
          return Column(
            children: attributes
                .map((arg) => SliderWithText(
              text: arg.name,
              onSliderChanged: (value) {
                arg.value = value;
              },
              currentState: arg.value,
              rangeStart: arg.rangeStart,
              rangeEnd: arg.rangeEnd,
            ))
                .toList(),
          );
        }
        return const Center(child: Text("Please choose team and user"));
      }
    }
    return const Center(child: Text("No Attributes"));
  }

  List<Argument> getArguments(List<Attribute>? attributes) {
    List<Argument> args = [];

    if (attributes != null) {
      for (var value in attributes) {
        args.add(Argument(value.name, value.rangeStart.toDouble(), value.id,
            value.threshold, value.rangeStart, value.rangeEnd));
      }
    }

    return args;
  }

  void getTeamUsers(int teamId) {
    AppDatabase.getTeamUsers(teamId).whenComplete(() => {
          setState(() {
            teamUsers = AppDatabase.teamUsers;
          })
        });
  }

  void fetchData() async{
    teamDropdownValue = null;
    userDropdownValue = null;
    teamUsers = null;
    AppDatabase.getAttributes().whenComplete(() => {
      setState(() {
        attributes = getArguments(AppDatabase.attributes);
      })
    });
    AppDatabase.getTeams().whenComplete(() => {
      setState(() {
        teams = AppDatabase.teams;
      })
    });
  }
}
