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
  List<Attribute>? attributes;

  @override
  Widget build(BuildContext context) {
    AppDatabase.getAttributes().whenComplete(() => {
      setState((){
        attributes = AppDatabase.attributes;
      })
    });
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
          ),
          Expanded(
            child: (attributes != null && attributes!.isNotEmpty) ?
            ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Entry ${attributes![index].name}'),
                          IconButton(
                              color:Colors.orange,
                              onPressed: (){
                                displayAddAttributeDialog(context, attributes?[index]);
                              },
                              icon: const Icon(Icons.edit)
                          )
                        ]
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: attributes!.length
            )
                : const Center (child: Text("No attributes"),),
          )
        ],
      ),
    );
  }

  Future<void> displayAddAttributeDialog(BuildContext context, [Attribute? attribute]) async{
    String valueName = attribute?.name ?? "";
    String valueThreshold = attribute?.threshold.toString() ?? "";
    String valueRangeStart = attribute?.rangeStart.toString() ?? "";
    String valueRangeEnd = attribute?.rangeEnd.toString() ?? "";
    String errorText = "";

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
                        if(attribute == null){
                          AppDatabase.insertAttribute(Attribute(-1, valueName, int.parse(valueThreshold), int.parse(valueRangeStart), int.parse(valueRangeEnd)));
                        }else{
                          AppDatabase.updateAttribute(Attribute(attribute.id, valueName, int.parse(valueThreshold), int.parse(valueRangeStart), int.parse(valueRangeEnd)));
                        }
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