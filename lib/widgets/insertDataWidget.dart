import 'package:flutter/material.dart';
import 'package:fluttertest/widgets/sliderWithTextWidget.dart';

import '../classes/argument.dart';

class InsertDataPage extends StatefulWidget{
  const InsertDataPage({super.key});

  @override
  State<StatefulWidget> createState() => InsertDataPageState();
}

class InsertDataPageState extends State<InsertDataPage>{

  final TextEditingController _textFieldController = TextEditingController();

  var args = <Argument>[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Data"),
      ),
      body: Column(
        children: <Widget>[
          TextButton(
              onPressed: (){
                displayDialog(context);
              },
              child: const Text("Add Attribute"),
          ),
          getSliderWidgets(args),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  '/data',
                  arguments: args
              );
            },
            child: const Text('Send Data'),
          ),
        ],
      ),
    );
  }

  Widget getSliderWidgets(List<Argument> args){
    if(args.isNotEmpty){
      return Column(
        children: args.map((arg) =>
            SliderWithText(
                text: arg.name,
                onSliderChanged: (value){arg.value = value;},
                currentState: arg.value)
        ).toList(),
      );
    }
    return const Text("No Attributes");
  }

  Future<void> displayDialog(BuildContext context) async{
    var valueText = "";
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Add new Attribute"),
            content: TextField(
              onChanged: (value){
                valueText = value;
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Name"),
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
                    args.add(Argument(valueText, 50));
                    Navigator.pop(context);
                  });
                },
              )
            ]
          );
        }
    );
  }
}