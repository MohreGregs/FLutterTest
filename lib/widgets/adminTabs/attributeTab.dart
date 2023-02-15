import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/entities/attribute.dart';
import 'package:fluttertest/widgets/dialogs/addAttributeDialog.dart';

import '../../database/database.dart';

class AttributeTab extends StatefulWidget{
  const AttributeTab({super.key});

  @override
  AttributeTabState createState() => AttributeTabState();

}

class AttributeTabState extends State<AttributeTab>{
  List<Attribute>? attributes;

  @override
  void initState() {
    AppDatabase.getAttributes().whenComplete(() => {
      setState((){
        attributes = AppDatabase.attributes;
      })
    });
    super.initState();
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
    return showDialog(
        context: context,
        builder: (context){
          return AddAttributeDialog(attribute: attribute,);
        }
    );
  }
}