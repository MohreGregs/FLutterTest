import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../database/database.dart';
import '../../database/entities/user.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key, this.user});

  @override
  State<StatefulWidget> createState() => AddUserState();

  final User? user;
}

class AddUserState extends State<AddUserDialog> {
  var nameController = TextEditingController();
  var errorText = "";

  @override
  void initState() {
    nameController.text = widget.user?.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(locale!.newUser),
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
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Text(locale.cancel),
        ),
        TextButton(
          child: Text(locale.ok),
          onPressed: () {
            setState(() {
              if (nameController.text == "") {
                setState(() {
                  errorText = locale.nameError;
                });
              } else {
                if (widget.user != null) {
                  AppDatabase.updateUser(
                      User(widget.user!.id, nameController.text));
                } else {
                  AppDatabase.insertUser(User(-1, nameController.text));
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
