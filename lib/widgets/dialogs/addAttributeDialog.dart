import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/entities/attribute.dart';

import '../../database/database.dart';

class AddAttributeDialog extends StatefulWidget{
  const AddAttributeDialog({super.key, this.attribute});

  @override
  State<StatefulWidget> createState() => AddAttributeState();

  final Attribute? attribute;
}

class AddAttributeState extends State<AddAttributeDialog>{
  var nameController = TextEditingController();
  var thresholdController = TextEditingController();
  var rangeStartController = TextEditingController();
  var rangeEndController = TextEditingController();
  String errorText = "";

  @override
  void initState() {
    nameController.text = widget.attribute?.name ?? "";
    thresholdController.text = widget.attribute?.threshold.toString() ?? "0";
    rangeStartController.text = widget.attribute?.rangeStart.toString() ?? "";
    rangeEndController.text = widget.attribute?.rangeEnd.toString() ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Add new Attribute"),
        content: Column(
          children: [
            Text(errorText, style: const TextStyle(color: Colors.redAccent),),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: thresholdController,
              decoration: const InputDecoration(hintText: "Threshold"),
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
            ),
            TextField(
              controller: rangeStartController,
              decoration: const InputDecoration(hintText: "Range Start"),
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
            ),
            TextField(
              controller: rangeEndController,
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
                if(int.parse(rangeStartController.text) >= int.parse(rangeEndController.text)){
                  setState(() {
                    errorText = "range start should be smaller than range end";
                  });
                }else if(nameController.text == ""){
                  setState(() {
                    errorText = "please insert name";
                  });
                }else{
                  if(thresholdController.text == ""){
                    thresholdController.text = "0";
                  }
                  if(widget.attribute == null){
                    AppDatabase.insertAttribute(Attribute(-1, nameController.text, int.parse(thresholdController.text), int.parse(rangeStartController.text), int.parse(rangeEndController.text)));
                  }else{
                    AppDatabase.updateAttribute(Attribute(widget.attribute!.id, nameController.text, int.parse(thresholdController.text), int.parse(rangeStartController.text), int.parse(rangeEndController.text)));
                  }
                  Navigator.pop(context);
                }
              });
            },
          )
        ]
    );
  }

}