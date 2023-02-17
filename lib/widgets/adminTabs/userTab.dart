import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/widgets/dialogs/addUserDialog.dart';

import '../../database/database.dart';
import '../../database/entities/user.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  UserTabState createState() => UserTabState();
}

class UserTabState extends State<UserTab> {
  List<User>? users;

  @override
  void initState() {
    super.initState();
    fetchData();
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
              const Text("Users", style: TextStyle(fontSize: 20)),
              IconButton(
                color: Colors.orange,
                onPressed: () {
                  displayAddUserDialog(context).then((value) => {fetchData()});
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
              child: (users != null && users!.isNotEmpty)
                  ? ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          color: Colors.white,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Entry ${users![index].name}'),
                                IconButton(
                                    color: Colors.orange,
                                    onPressed: () {
                                      displayAddUserDialog(context, users?[index]).then((value) => {
                                        fetchData()
                                      });
                                    },
                                    icon: const Icon(Icons.edit))
                              ]),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemCount: users!.length)
                  : const Center(
                      child: Text("No users"),
                    ))
        ],
      ),
    );
  }

  Future<void> displayAddUserDialog(BuildContext context, [User? user]) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AddUserDialog(
            user: user,
          );
        });
  }

  void fetchData() async {
    AppDatabase.getUsers().whenComplete(() => {
          setState(() {
            users = AppDatabase.users;
          })
        });
  }
}
