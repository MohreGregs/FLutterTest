import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/widgets/adminTabs/attributeTab.dart';
import 'package:fluttertest/widgets/adminTabs/teamTab.dart';
import 'package:fluttertest/widgets/adminTabs/userTab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminWidget extends StatefulWidget {
  const AdminWidget({super.key});

  @override
  State<StatefulWidget> createState() => AdminState();
}

class AdminState extends State<AdminWidget> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(locale!.admin),
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: locale.users,
              ),
              Tab(
                icon: Icon(Icons.people),
                text: locale.teams,
              ),
              Tab(
                icon: Icon(Icons.bubble_chart),
                text: locale.attributes,
              ),
            ]),
          ),
          body: const TabBarView(
            children: [UserTab(), TeamTab(), AttributeTab()],
          )),
    );
  }
}
