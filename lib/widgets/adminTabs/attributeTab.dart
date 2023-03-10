import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/entities/attribute.dart';
import 'package:fluttertest/widgets/dialogs/addAttributeDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(locale!.attributes, style: const TextStyle(fontSize: 20)),
              IconButton(
                color:Colors.orange,
                onPressed: (){
                  displayAddAttributeDialog(context).then((value) => {
                    fetchData()
                  });
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
                          Text(attributes![index].name),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  color:Colors.orange,
                                  onPressed: (){
                                    displayAddAttributeDialog(context, attributes![index]).then((value) => {
                                      fetchData()
                                    });
                                  },
                                  icon: const Icon(Icons.edit)
                              ),
                              IconButton(
                                  color:Colors.orange,
                                  onPressed: (){
                                    AppDatabase.deleteAttribute(attributes![index].id).then((value) => {
                                      fetchData()
                                    });
                                  },
                                  icon: const Icon(Icons.delete)
                              )
                            ],
                          )
                        ]
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemCount: attributes!.length
            )
                : Center (child: Text(locale.noAttributes),),
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

  void fetchData() async{
    AppDatabase.getAttributes().whenComplete(() => {
      setState((){
        attributes = AppDatabase.attributes;
      })
    });
  }
}