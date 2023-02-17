import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/entities/attribute.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var locale = AppLocalizations.of(context);
    return AlertDialog(
        title: Text(locale!.newAttribute),
        content: Column(
          children: [
            Text(errorText, style: const TextStyle(color: Colors.redAccent),),
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: locale.name),
            ),
            TextField(
              controller: thresholdController,
              decoration: InputDecoration(hintText: locale.threshold),
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
            ),
            TextField(
              controller: rangeStartController,
              decoration: InputDecoration(hintText: locale.rangeStart),
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
            ),
            TextField(
              controller: rangeEndController,
              decoration: InputDecoration(hintText: locale.rangeEnd),
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
            child: Text(locale.cancel),
          ),
          TextButton(
            child: Text(locale.ok),
            onPressed: (){
              setState(() {
                if(int.parse(rangeStartController.text) >= int.parse(rangeEndController.text)){
                  setState(() {
                    errorText = locale.rangeError;
                  });
                }else if(nameController.text == ""){
                  setState(() {
                    errorText = locale.nameError;
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