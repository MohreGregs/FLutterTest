import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/classes/custom_icons_icons.dart';
import 'package:fluttertest/widgets/dialogs/addUsersToTeamDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../database/database.dart';
import '../../database/entities/team.dart';
import '../dialogs/addTeamDialog.dart';

class TeamTab extends StatefulWidget{
  const TeamTab({super.key});

  @override
  TeamTabState createState() => TeamTabState();

}

class TeamTabState extends State<TeamTab>{
  List<Team>? teams;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
      var locale = AppLocalizations.of(context);
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(locale!.teams, style: const TextStyle(fontSize: 20)),
                IconButton(
                  color:Colors.orange,
                  onPressed: (){
                    displayAddTeamDialog(context).then((value) => {
                      fetchData()
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Expanded(
                child: (teams != null && teams!.isNotEmpty) ?
                    ListView.separated(
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(teams![index].name),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          color:Colors.orange,
                                          onPressed: (){
                                            addUsersDialog(context, teams![index]);
                                          },
                                          icon: const Icon(CustomIcons.person_add)
                                      ),
                                      IconButton(
                                          color:Colors.orange,
                                          onPressed: (){
                                            displayAddTeamDialog(context, teams?[index]).then((value) => {
                                              fetchData()
                                            });
                                          },
                                          icon: const Icon(Icons.edit)
                                      ),
                                      IconButton(
                                          color:Colors.orange,
                                          onPressed: (){
                                            AppDatabase.deleteTeam(teams![index].id).then((value) => {
                                              fetchData()
                                            });
                                          },
                                          icon: const Icon(Icons.delete)
                                      )
                                    ],
                                  )
                                ]
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemCount: teams!.length
                    )
                    : Center(child: Text(locale.noTeams))
            )
          ],
        ),
      );
  }

  Future<void> displayAddTeamDialog(BuildContext context, [Team? team]) async{
    return showDialog(
        context: context,
        builder: (context){
          return AddTeamDialog(team: team);
        }
    );
  }

  Future<void> addUsersDialog(BuildContext context, Team team) async{
    return showDialog(
        context: context,
        builder: (context){
          return AddUsersToTeamDialog(team: team);
        }
    );
  }

  void fetchData() async{
    AppDatabase.getTeams().whenComplete(() => {
      setState((){
        teams = AppDatabase.teams;
      })
    });
  }
}