import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var locale = AppLocalizations.of(context);
    return AlertDialog(
      title:  Text(locale!.newTeam),
      content: Column(
        children: [
          Text(errorText, style: const TextStyle(color: Colors.redAccent),),
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: locale.name),
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
          child: Text(locale.cancel),
        ),
        TextButton(
          child: Text(locale.ok),
          onPressed: (){
            setState(() {
              if(nameController.text == ""){
                setState(() {
                  errorText = locale.nameError;
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