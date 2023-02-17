import 'package:flutter/material.dart';
import 'package:fluttertest/database/database.dart';
import 'package:fluttertest/database/entities/attribute.dart';
import 'package:fluttertest/database/entities/point.dart';
import 'package:fluttertest/widgets/sliderWithTextWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../classes/argument.dart';
import '../classes/custom_icons_icons.dart';
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
    var locale = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(locale!.insertPoints),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/data');
                },
                icon: const Icon(Icons.bar_chart)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin')
                      .then((value) => {fetchData()});
                },
                icon: const Icon(Icons.accessible_forward_rounded))
          ],
        ),
        body: (teams != null &&
                teams!.isNotEmpty &&
                attributes != null &&
                attributes!.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    DropdownButton(
                        isExpanded: true,
                        hint: Text(locale.chooseTeam),
                        value: teamDropdownValue,
                        icon: const Icon(CustomIcons.arrow_drop_down),
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
                    (teamUsers != null)
                        ? (teamUsers!.isNotEmpty)
                            ? DropdownButton(
                                isExpanded: true,
                                hint: Text(locale.chooseUser),
                                value: userDropdownValue,
                                icon: const Icon(CustomIcons.arrow_drop_down),
                                items: teamUsers
                                    ?.map<DropdownMenuItem<User>>((User user) {
                                  return DropdownMenuItem<User>(
                                    value: user,
                                    child: Text(user.name),
                                  );
                                }).toList(),
                                onChanged: (Object? value) {
                                  setState(() {
                                    userDropdownValue = value as User;
                                  });
                                })
                            : Text(locale.noUsersForTeam,
                                style: const TextStyle(color: Colors.redAccent))
                        : const Text(""),
                    getSliderWidgets(attributes, locale),
                    (userDropdownValue != null)
                        ? TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              attributes?.forEach((element) {
                                AppDatabase.insertPoint(Point(
                                    -1,
                                    element.value,
                                    DateTime.now(),
                                    element.id,
                                    teamDropdownValue!.id,
                                    userDropdownValue!.id));
                              });
                              fetchData();
                            },
                            child: Text(locale.sendPoint),
                          )
                        : Center(child: Text(locale.chooseUserAndTeam)),
                  ],
                ))
            : Center(
                child: Text(locale.firstInsertData),
              ));
  }

  Widget getSliderWidgets(List<Argument>? attributes, AppLocalizations locale) {
    if (attributes != null) {
      if (attributes.isNotEmpty) {
        if (teamDropdownValue != null && userDropdownValue != null) {
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
        return const Text("");
      }
    }
    return Center(child: Text(locale.noAttributes));
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

  void fetchData() async {
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
