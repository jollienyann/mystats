import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Edit extends StatefulWidget {
  String dbValue;
  String textValue;

  Edit(this.dbValue, this.textValue);

  @override
  _EditState createState() => _EditState(dbValue, textValue);
}

class _EditState extends State<Edit> {
  String dbValue;
  String textValue;

  String value = "";
  String category =  "";

  _EditState(this.dbValue, this.textValue);

  final textfieldContent = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textfieldContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit')),
      body: Padding(
        padding: EdgeInsets.only(top: 25),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    print(dbValue);
                    final now = new DateTime.now();
                    String formatter = DateFormat('yyyy-MM-dd').format(now);
                    print(formatter);
                    DBHelper.getDataToday(dbValue,"'"+dbValue+"'", formatter.toString())
                        .then((res) {
                      String result = res[0]['Today'].toString();
                      category = res[0]['category'].toString();
                      print(category);
                      setState(() {
                        value = result;
                      });
                    });
                  },
                  child: Text("Today")),
              ElevatedButton(onPressed: () {
                final now = new DateTime.now().subtract(Duration(days:1));
                String formatter = DateFormat('yyyy-MM-dd').format(now);
                print(formatter);
                DBHelper.getDataYesterday(dbValue,"'"+dbValue+"'", formatter.toString())
                    .then((res) {
                  print("RES "+res.toString());
                  String result = "";
                  if(res.toString() == '[]'){
                    result = "0";
                  }
                  result = res[0]['Today'].toString();
                  setState(() {
                    value = result;
                  });
                });
              }, child: Text("Yesterday")),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: textfieldContent,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: value,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      print(textfieldContent.text);
                      final now = new DateTime.now();
                      String formatter = DateFormat('yyyy-MM-dd').format(now);
                      if(checkInput(int.parse(textfieldContent.text), category) == true){
                        DBHelper.updateStats(dbValue, textfieldContent.text, formatter);
                        textfieldContent.clear();
                        Fluttertoast.showToast(
                            msg: "Saved",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      else {
                        Fluttertoast.showToast(
                            msg: "Please enter valid value",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        textfieldContent.clear();
                      }

                    },
                    child: Text("Save"))
              ],
            ),
          )
        ]),
      ),
    );
  }
}

bool checkInput(int input, String category){
  bool ok = true;
  if(category == "2"){
    if(input < 0 || input > 1){
      ok = false;
    }
  }else if (category == "1"){
    if(input < 0 || input > 4){
      ok = false;
    }
  }
  return ok;
}

