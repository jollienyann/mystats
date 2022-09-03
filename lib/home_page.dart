import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //https://stackoverflow.com/questions/60053914/flutter-onchanged-behaviour-in-radios-with-multiple-groups-not-working-as-expect

  //For items with 5 selectable options
  List<String> labels5 = ['1', '2', '3', '4', '5'];
  //For items with 2 selecteable options
  List<String> labels2 = ['1', '2'];

  //Create attendance list to hold attendance
  Map<String, String> attendance = {};

  //Define you function that takes click
  void _onClick(String value) {
    print(value);
  }

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    var rng = Random();
                    ListObject lo = new ListObject((rng.nextInt(100).toString()),valueText,valueText.toLowerCase(),"1","1");
                    DBHelper.saveListObject(lo);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  String codeDialog = "";
  String valueText = "";
  int iconCode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyStats'),automaticallyImplyLeading: false,),
      body: FutureBuilder(
        future: DBHelper.getList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            print("no data");
            return Container();
          } else {
            return Container(
                color: Colors.white,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data[index].category.toString() == "1") {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.cyan,
                            elevation: 10,
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  snapshot.data[index].textValue.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              leading: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Icon(IconData(int.parse(snapshot.data[index].icon.toString()), fontFamily: 'MaterialIcons')),
                                alignment: Alignment.center,
                              ),
                              trailing: Column(
                                children: <Widget>[],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: labels5.map((s) {
                                        return Flexible(
                                          child: Column(
                                            children: <Widget>[
                                              Radio(
                                                groupValue: attendance[snapshot.data[index].id],
                                                value: s,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    print(snapshot.data[index].textValue.toString() + " value" + newValue.toString());
                                                    attendance[snapshot.data[index].id.toString()] = newValue.toString();
                                                    String result;
                                                    final now = new DateTime.now();
                                                    String formatter = DateFormat('yyyy-MM-dd').format(now);
                                                    DBHelper.getDate(formatter.toString()).then((res) {
                                                      result = res.toString();
                                                      print(result);
                                                      if (result == '[]') {
                                                        print(snapshot.data[index].dbValue.toString() + " Index" + index.toString());
                                                        DBHelper.saveStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                      } else if (result != '[]') {
                                                        print(snapshot.data[index].dbValue.toString() + " Index" + index.toString());
                                                        DBHelper.updateStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                      }
                                                    });
                                                  });
                                                },
                                              ),
                                              Text(s,
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.data[index].category.toString() == "2") {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.cyan,
                            elevation: 10,
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  snapshot.data[index].textValue.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              leading: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: Icon(IconData(int.parse(snapshot.data[index].icon.toString()), fontFamily: 'MaterialIcons')),
                                alignment: Alignment.center,
                              ),
                              trailing: Column(
                                children: <Widget>[],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: labels2.map((s) {
                                        return Flexible(
                                          child: Column(
                                            children: <Widget>[
                                              Radio(
                                                groupValue: attendance[snapshot.data[index].id],
                                                value: s,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    print(snapshot.data[index].textValue.toString() + " value" + newValue.toString());
                                                    attendance[snapshot.data[index].id.toString()] = newValue.toString();
                                                    String result;
                                                    final now = new DateTime.now();
                                                    String formatter = DateFormat('yyyy-MM-dd').format(now);
                                                    DBHelper.getDate(formatter.toString()).then((res) {
                                                      result = res.toString();
                                                      print(result);
                                                      if (result == '[]') {
                                                        print(snapshot.data[index].dbValue.toString() + " Index" + index.toString());
                                                        DBHelper.saveStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                      } else if (result != '[]') {
                                                        print(snapshot.data[index].dbValue.toString() + " Index" + index.toString());
                                                        DBHelper.updateStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                      }
                                                    });
                                                  });
                                                } ,
                                              ),
                                              Text(s,
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Text("Some text");
                    })
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_displayTextInputDialog(context);
          DBHelper.getList();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListObject {
  String? id;
  String? textValue;
  String? dbValue;
  String? category;
  String? icon;

  ListObject(this.id, this.textValue, this.dbValue, this.category, this.icon);
// can also add 'required' keyword
}
