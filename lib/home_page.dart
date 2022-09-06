import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';
import 'package:intl/intl.dart';
import 'package:sam/screens/add_newObject.dart';
import 'package:sam/stats_screens/graphs.dart';

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

  String codeDialog = "";
  String valueText = "";
  int iconCode = 0;



  @override
  Widget build(BuildContext context) {
    String dateFromDb = DBHelper.getLastDate().toString();
    String formatter = DateFormat('yyyy-MM-dd').format(new DateTime.now());
    if(dateFromDb != formatter){
      for(int i = 0 ; i < 10; i++){

      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('MyStats'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Graphs()));
            },
            child: Text("Stats"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
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
                      if(snapshot.data[index].doneDate.toString() != formatter){
                        DBHelper.updateObject("0",formatter,snapshot.data[index].dbValue.toString());
                      }
                      if (snapshot.data[index].category.toString() == "1" && snapshot.data[index].doneToday.toString() == "0") {
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
                                                        DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                        snapshot.data.removeAt(index);
                                                      } else if (result != '[]') {
                                                        print(snapshot.data[index].dbValue.toString() + " Index" + index.toString());
                                                        DBHelper.updateStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                        DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                        snapshot.data.removeAt(index);
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
                      } else if (snapshot.data[index].category.toString() == "2" && snapshot.data[index].doneToday.toString() == "0") {
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
                                                        DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                        snapshot.data.removeAt(index);
                                                      } else if (result != '[]') {
                                                        print(snapshot.data[index].dbValue.toString() + " Index" + index.toString());
                                                        DBHelper.updateStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                        DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                        snapshot.data.removeAt(index);
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
                      return Text("");
                    })
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddObject()));
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
  String? doneToday;
  String? doneDate;

  ListObject(this.id, this.textValue, this.dbValue, this.category, this.icon, this.doneToday, this.doneDate);
// can also add 'required' keyword
}
