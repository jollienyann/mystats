import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';

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
                    DBHelper.getDataToaday(dbValue, formatter.toString())
                        .then((res) {
                      print(res);
                      String result = res[0]['Today'].toString();
                      setState(() {
                        value = result;
                      });
                    });
                  },
                  child: Text("Today")),
              ElevatedButton(onPressed: () {}, child: Text("Yesterday")),
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

bool checkInput(int input){
  if(input > 4){
    return false;
  }
  return true;
}

Future? _fetchDataToday(String dbValue, String date) async {
  var result = await DBHelper.getDataToaday(dbValue, date);
  print(result.toString());
  return result;
}
