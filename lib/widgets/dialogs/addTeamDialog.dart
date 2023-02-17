import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../database/entities/team.dart';

class AddTeamDialog extends StatefulWidget{
  const AddTeamDialog({super.key, this.team});

  @override
  State<StatefulWidget> createState() => AddTeamState();

  final Team? team;
}

class AddTeamState extends State<AddTeamDialog>{
  var nameController = TextEditingController();
  var errorText = "";

  @override
  void initState() {
    nameController.text = widget.team?.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new Team"),
      content: Column(
        children: [
          Text(errorText, style: const TextStyle(color: Colors.redAccent),),
          TextField(
            controller: nameController,
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
              if(nameController.text == ""){
                setState(() {
                  errorText = "Name required";
                });
              }else{
                if(widget.team != null){
                  AppDatabase.updateTeam(Team(widget.team!.id, nameController.text));
                }else{
                  AppDatabase.insertTeam(Team(-1, nameController.text));
                }
                Navigator.pop(context);
              }
            });
          },
        )
      ],
    );
  }

}