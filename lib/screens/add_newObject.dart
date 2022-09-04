
import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';
import 'package:sam/home_page.dart';

class AddObject extends StatefulWidget {

  @override
  State<AddObject> createState() => _AddObjectState();
}

class _AddObjectState extends State<AddObject> {

  String newValue = "";
  TextEditingController itemController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add object')
      ),
      body: Padding(
        padding: EdgeInsets.all(36.0),
        child: Column(
          children: [
            TextField(
              controller: itemController,
                decoration: InputDecoration(
                  labelText: "Item name", //babel text
                  hintText: "Enter item name", //hint text
                  hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), //hint text style
                  labelStyle: TextStyle(fontSize: 18, color: Colors.cyan), //label style
                ),
            ),
            ListTile(
              title: const Text('Category 1'),
              leading: Radio(
                value: "1",
                groupValue: newValue,
                onChanged: (value) {
                  setState(() {
                    newValue = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Category 2'),
              leading: Radio(
                value: "2",
                groupValue: newValue,
                onChanged: (value) {
                  setState(() {
                    newValue = value.toString();
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print("Value from category"+newValue);
                  DBHelper.saveListObject(new ListObject("44", itemController.text, "v100", newValue, "0xee29"));
                },
                child: Text("SaveValues"))
          ],
        ),
      ),
    );
  }
}