import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/classes/userWithBool.dart';
import 'package:fluttertest/database/entities/teamUser.dart';
import 'package:fluttertest/widgets/dialogs/addUsersToTeamDialog.dart';

import '../../database/database.dart';
import '../../database/entities/team.dart';
import '../../database/entities/user.dart';
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
    AppDatabase.getTeams().whenComplete(() => {
      setState((){
        teams = AppDatabase.teams;
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Teams", style: TextStyle(fontSize: 20)),
                IconButton(
                  color:Colors.orange,
                  onPressed: (){
                    displayAddTeamDialog(context);
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
                                  Text('Entry ${teams![index].name}'),
                                  IconButton(
                                      color:Colors.orange,
                                      onPressed: (){
                                        addUsersDialog(context, teams![index]);
                                      },
                                      icon: const Icon(Icons.add_reaction)
                                  ),
                                  IconButton(
                                      color:Colors.orange,
                                      onPressed: (){
                                        displayAddTeamDialog(context, teams?[index]);
                                      },
                                      icon: const Icon(Icons.edit)
                                  )
                                ]
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                        itemCount: teams!.length
                    )
                    : const Center(child: Text("No teams"))
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
}