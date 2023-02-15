import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/widgets/adminTabs/attributeTab.dart';
import 'package:fluttertest/widgets/adminTabs/teamTab.dart';
import 'package:fluttertest/widgets/adminTabs/userTab.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({super.key});

  @override
  State<StatefulWidget> createState() => AdminState();
}

class AdminState extends State<AdminWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Admin"),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: "Users",
              ),
              Tab(
                icon: Icon(Icons.people),
                text: "Teams",
              ),
              Tab(
                icon: Icon(Icons.bubble_chart),
                text: "Attributes",
              ),
            ]),
          ),
          body: const TabBarView(
            children: [UserTab(), TeamTab(), AttributeTab()],
          )),
    );
  }
}
