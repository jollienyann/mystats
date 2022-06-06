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

  List<ListObject> options = [
    ListObject(id: "1", textValue: "My Day", dbValue: "myDay"),
    ListObject(id: "2", textValue: "Hangover night", dbValue: "hangoverNight"),
    ListObject(id: "3", textValue: "Alcool", dbValue: "alcool"),
    ListObject(id: "4", textValue: "Sport > 1h", dbValue: "sportMore1"),
    ListObject(id: "5", textValue: "Sleep > 8h", dbValue: "sleepMore8"),
    ListObject(id: "6", textValue: "Nap", dbValue: "nap"),
    ListObject(id: "7", textValue: "Really sick", dbValue: "reallySick"),
    ListObject(id: "8", textValue: "Headache", dbValue: "headache"),
    ListObject(id: "9", textValue: "Work > 4h", dbValue: "workMore4")
  ];

  List<String> labels=['1','2','3','4','5'];

  //Create attendance list to hold attendance
  Map<String,String> attendance={};

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
                    ListObject lo = new ListObject();
                    lo.textValue = valueText;
                    lo.dbValue = valueText.toLowerCase();
                    options.add(lo);
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
  int iconCode=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Text('MyStats')),
      body: Container(
          color:Colors.white,
          child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color:Colors.cyan,
                    elevation: 10,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          options[index].textValue.toString(),
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color:Colors.black),
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
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
                              children: labels.map((s){
                                return Flexible(
                                  child: Column(
                                    children: <Widget>[
                                      Radio(
                                        groupValue: attendance[options[index].id],
                                        value: s,
                                        onChanged: (newValue) {
                                          setState((){
                                            print(options[index].textValue.toString() + " value" +newValue.toString());
                                            attendance[options[index].id.toString()]=newValue.toString();
                                            String result;
                                            final now = new DateTime.now();
                                            String formatter = DateFormat('yyyy-MM-dd').format(now);
                                            DBHelper.getDate(formatter.toString()).then((res) {
                                              result = res.toString();
                                              print(result);
                                              if (result == '[]') {
                                                print(options[index].dbValue.toString()+" Index"+index.toString());
                                                DBHelper.saveStats(options[index].dbValue.toString(),newValue.toString());
                                              }else if(result != '[]'){
                                                print(options[index].dbValue.toString()+" Index"+index.toString());
                                                DBHelper.updateStats(options[index].dbValue.toString(), newValue.toString());
                                              }
                                            });
                                            options.removeAt(index);//remove the item
                                          });
                                        },
                                      ),
                                      Text(s,style:TextStyle(color:Colors.black))
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
              })
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListObject{
  String? id;
  String? textValue;
  String? dbValue;

  ListObject({this.id, this.textValue, this.dbValue});
// can also add 'required' keyword
}

