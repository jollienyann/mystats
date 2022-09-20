import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';
import 'package:intl/intl.dart';
import 'package:sam/screens/add_newObject.dart';
import 'package:sam/stats_screens/graphs_two.dart';
import 'package:sam/stats_screens/graphs_one.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //https://stackoverflow.com/questions/60053914/flutter-onchanged-behaviour-in-radios-with-multiple-groups-not-working-as-expect

  //Future to get list from db
  late Future? _myList;

  //For items with 5 selectable options
  List<String> labels5 = ['1', '2', '3', '4', '5'];
  //For items with 2 selecteable options
  List<String> labels2 = ['1', '2'];

  //Define you function that takes click
  void _onClick(String value) {
    print(value);
  }

  TextEditingController _textFieldController = TextEditingController();

  String codeDialog = "";
  String valueText = "";
  int iconCode = 0;

  //Getting list from db in init state to prevent reloading multiple times
  @override
  void initState() {
    super.initState();
    _myList = _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    String formatter = DateFormat('yyyy-MM-dd').format(new DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('MyStats'),
        automaticallyImplyLeading: false
      ),
      body: FutureBuilder(
        future: _myList,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.error);
            return Container();
          } else {
            return Container(
                color: Colors.white,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if(snapshot.data[index].doneDate.toString() != formatter){
                        DBHelper.updateObject("0",formatter.toString(),snapshot.data[index].dbValue.toString());
                      }
                      if (snapshot.data[index].category.toString() == "1" && snapshot.data[index].doneToday.toString() == "0") {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            color: Colors.orange[200],
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
                                  color: Colors.orange[400],
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
                                                groupValue: snapshot.data[index].id,
                                                value: s,
                                                onChanged: (newValue) {
                                                  String result;
                                                  final now = new DateTime.now();
                                                  String formatter = DateFormat('yyyy-MM-dd').format(now);
                                                  DBHelper.getDate(formatter.toString()).then((res) {
                                                    result = res.toString();
                                                    print("RESULT"+result);
                                                    if (result == '[]') {
                                                      print("Save");
                                                      print("For: "+snapshot.data[index].dbValue.toString() + " Value" + newValue.toString()+ " Date: "+formatter.toString());
                                                      DBHelper.saveStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                      DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                    } else if (result != '[]') {
                                                      print("Update");
                                                      print("For: "+snapshot.data[index].dbValue.toString() + " Value" + newValue.toString()+ " Date: "+formatter.toString());
                                                      DBHelper.updateStats(snapshot.data[index].dbValue.toString(), newValue.toString(),formatter.toString());
                                                      DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                    }
                                                  setState(() {
                                                    snapshot.data.removeAt(index);
                                                    });
                                                  });
                                                },
                                              ),
                                              Text(s,
                                                  style: TextStyle(color: Colors.black))
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            color: Colors.orange[200],
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
                                  color: Colors.orange[400],
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
                                                groupValue: snapshot.data[index].id,
                                                value: s,
                                                onChanged: (newValue) {
                                                  String result;
                                                  final now = new DateTime.now();
                                                  String formatter = DateFormat('yyyy-MM-dd').format(now);
                                                  DBHelper.getDate(formatter.toString()).then((res) {
                                                    result = res.toString();
                                                    print(result);
                                                    if (result == '[]') {
                                                      print("Save");
                                                      print("For: "+snapshot.data[index].dbValue.toString() + " Value" + newValue.toString()+ " Date: "+formatter.toString());
                                                      DBHelper.saveStats(snapshot.data[index].dbValue.toString(), newValue.toString());
                                                      DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                    } else if (result != '[]') {
                                                      print("Update");
                                                      print("For: "+snapshot.data[index].dbValue.toString() + " Value" + newValue.toString()+ " Date: "+formatter.toString());
                                                      DBHelper.updateStats(snapshot.data[index].dbValue.toString(), newValue.toString(),formatter.toString());
                                                      DBHelper.updateObject("1",formatter,snapshot.data[index].dbValue.toString());
                                                    }
                                                  setState(() {
                                                    snapshot.data.removeAt(index);
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
      floatingActionButton:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(child: const Icon(Icons.add), onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddObject()));
            }),
            RaisedButton(child: Text('Stats 2'), onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GraphsTwo()));
            }),
            RaisedButton(child: Text('Stats 1'), onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GraphsOne()));
            }),
          ]
      ),
    );
  }
}

Future? _fetchList() async {
  var result = await DBHelper.getList();
  print(result);
  return result;
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
