import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/entities/teamUser.dart';

import '../../classes/userWithBool.dart';
import '../../database/database.dart';
import '../../database/entities/team.dart';
import '../../database/entities/user.dart';

class AddUsersToTeamDialog extends StatefulWidget{
  const AddUsersToTeamDialog({super.key, required this.team});

  @override
  State<StatefulWidget> createState() => AddUsersToTeamState();

  final Team team;
}

class AddUsersToTeamState extends State<AddUsersToTeamDialog>{
  List<UserWithBool> users = [];
  List<User> teamUsers = [];

  @override
  void initState() {
    AppDatabase.getTeamUsers(widget.team.id).whenComplete(() => {
      getUsers()
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose users of team ${widget.team.name}"),
      content: (users.isNotEmpty) ?
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Entry ${users[index].user.name}'),
                        Checkbox(value: users[index].value, onChanged: (value){
                          setState(() {
                            users[index].value = value!;
                          });
                        })
                      ]
                  ),
                );
              },
              itemCount: users.length,
            ),
          )
          : const Center (child: Text("No users"),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: (){
            setState(() {
              Navigator.pop(context);
            });
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: (){
            for (var user in users) {
              if(user.value && !isUserInTeam(user.user.id)){
                AppDatabase.insertTeamUser(TeamUser(-1, user.user.id, widget.team.id));
              }else if(!user.value && isUserInTeam(user.user.id)){
                AppDatabase.getTeamUserValidityOfTeam(widget.team.id).whenComplete(() =>
                {
                AppDatabase.deleteEntry(AppDatabase.teamUserValidity?.firstWhere((element) => element.teamId == widget.team.id && element.userId == user.user.id).id, "teamUser")
                });
              }
            }
            setState(() {
              Navigator.pop(context);
            });
          },
        )
      ],
    );
  }


  Future<void> getUsers()async {
    teamUsers = AppDatabase.teamUsers ?? [];
    AppDatabase.getUsers().whenComplete(() => {
      setState(() {
        users = [];
        AppDatabase.users?.forEach((element) {
          users.add(UserWithBool(isUserInTeam(element.id), element));
        });
      })
    });
  }

  bool isUserInTeam(int userId){
    for (var element in teamUsers) {
      if(element.id == userId) return true;
    }
    return false;
  }
}