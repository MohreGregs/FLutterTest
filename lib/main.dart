import 'package:flutter/material.dart';
import 'package:fluttertest/widgets/diagramWidget.dart';
import 'package:fluttertest/widgets/insertDataWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InsertDataPage(),
        '/data': (context) => const DiagramPage(),
      },
    );
  }
}