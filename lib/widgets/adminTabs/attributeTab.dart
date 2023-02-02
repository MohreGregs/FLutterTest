import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/entities/attribute.dart';

import '../../database/database.dart';

class AttributeTab extends StatefulWidget{
  const AttributeTab({super.key});

  @override
  AttributeTabState createState() => AttributeTabState();

}

class AttributeTabState extends State<AttributeTab>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Attributes", style: TextStyle(fontSize: 20)),
              IconButton(
                color:Colors.orange,
                onPressed: (){
                  displayAddAttributeDialog(context);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> displayAddAttributeDialog(BuildContext context) async{
    var valueName = "";
    var valueThreshold = "";
    var valueRangeStart = "";
    var valueRangeEnd = "";
    var errorText = "";

    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              title: const Text("Add new Attribute"),
              content: Column(
                children: [
                  Text(errorText),
                  TextField(
                    onChanged: (value){
                      valueName = value;
                    },
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    onChanged: (value){
                      valueThreshold = value;
                    },
                    decoration: const InputDecoration(hintText: "Threshold"),
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  ),
                  TextField(
                    onChanged: (value){
                      valueRangeStart = value;
                    },
                    decoration: const InputDecoration(hintText: "Range Start"),
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  ),
                  TextField(
                    onChanged: (value){
                      valueRangeEnd = value;
                    },
                    decoration: const InputDecoration(hintText: "Range End"),
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
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
                      if(int.parse(valueRangeStart) >= int.parse(valueRangeEnd)){
                        errorText = "range start should be smaller than range end";
                      }else{
                        AppDatabase.insertAttribute(Attribute(-1, valueName, int.parse(valueThreshold), int.parse(valueRangeStart), int.parse(valueRangeEnd)));
                        Navigator.pop(context);
                      }
                    });
                  },
                )
              ]
          );
        }
    );
  }
}