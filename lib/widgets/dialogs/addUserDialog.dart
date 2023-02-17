import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return AlertDialog(
      title: const Text("Add new User"),
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
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            setState(() {
              if (nameController.text == "") {
                setState(() {
                  errorText = "Name required";
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
