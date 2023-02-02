import 'package:flutter/material.dart';
import 'package:fluttertest/database/database.dart';
import 'package:fluttertest/database/entities/attribute.dart';
import 'package:fluttertest/widgets/sliderWithTextWidget.dart';

import '../classes/argument.dart';
import '../database/entities/user.dart';

class InsertDataPage extends StatefulWidget{
  const InsertDataPage({super.key});

  @override
  State<StatefulWidget> createState() => InsertDataPageState();

}

class InsertDataPageState extends State<InsertDataPage>{

  List<Argument>? attributes;

  @override
  Widget build(BuildContext context)  {
    AppDatabase.getAttributes().whenComplete(() => {
      setState(() {
        attributes = getArguments(AppDatabase.attributes);
      })
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Data"),
        actions: [
          IconButton(
              onPressed:() {
                Navigator.pushNamed(
                    context,
                    '/admin'
                );
              },
              icon: const Icon(Icons.accessible_forward_rounded)
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          getSliderWidgets(attributes),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  '/data'
              );
            },
            child: const Text('Send Data'),
          ),
        ],
      ),
    );
  }

  List<Argument> getArguments(List<Attribute>? attributes)  {
    List<Argument> args = [];

    if(attributes != null){
      for (var value in attributes) {
        args.add(Argument(value.name, value.rangeStart.toDouble(), value.id, value.threshold, value.rangeStart, value.rangeEnd));
      }
    }

    return args;
  }

  Widget getSliderWidgets(List<Argument>? attributes ){
    if(attributes != null){
      if(attributes.isNotEmpty){
        return Column(
          children: attributes.map((arg) =>
              SliderWithText(
                  text: arg.name,
                  onSliderChanged: (value){arg.value = value;},
                  currentState: arg.value,
                  rangeStart: arg.rangeStart,
                rangeEnd: arg.rangeEnd,
              )
          ).toList(),
        );
      }
    }
    return const Text("No Attributes");
  }
}