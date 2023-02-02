import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../database/entities/team.dart';

class TeamTab extends StatefulWidget{
  const TeamTab({super.key});

  @override
  TeamTabState createState() => TeamTabState();

}

class TeamTabState extends State<TeamTab>{
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
            )
          ],
        ),
      );
  }

  Future<void> displayAddTeamDialog(BuildContext context) async{
    var errorText = "";
    var valueName = "";
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Add new User"),
            content: Column(
              children: [
                Text(errorText),
                TextField(
                  onChanged: (value){
                    valueName = value;
                  },
                  decoration: const InputDecoration(hintText: "Name"),
                ),
              ],
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
                  setState(() {
                    if(valueName == ""){
                      errorText = "Name required";
                    }else{
                      AppDatabase.insertTeam(Team(-1, valueName));
                      Navigator.pop(context);
                    }
                  });
                },
              )
            ],
          );
        }
    );
  }
}