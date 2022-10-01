import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';
import '../stats_screens/graphs_one.dart';
import '../stats_screens/graphs_two.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  //Future to get list from db
  late Future? _myList;

  @override
  void initState() {
    super.initState();
    _myList = _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    String formatter = DateFormat('yyyy-MM-dd').format(new DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('MyStats'), automaticallyImplyLeading: false),
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
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          color: Colors.orange[200],
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                  children: [
                                Text(
                                  snapshot.data[index].textValue.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                    Icon(
                                      IconData(
                                          int.parse(snapshot.data[index].icon
                                              .toString()),
                                          fontFamily: 'MaterialIcons'),
                                      size: 50,
                                    ),
                                Flexible(
                                    child: FlatButton(
                                        color: Colors.transparent,
                                        onPressed: () {
                                          print("DATA " +
                                              snapshot.data[index].dbValue
                                                  .toString());
                                          //db Value to pass to grapghs screens
                                          String valueToPassDb = snapshot
                                              .data[index].dbValue
                                              .toString();
                                          String valueToPassText = snapshot
                                              .data[index].textValue
                                              .toString();
                                          //Open graphs 1
                                          if (snapshot.data[index].category
                                                  .toString() ==
                                              "1") {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GraphsOne(valueToPassDb,
                                                            valueToPassText)));
                                          }
                                          //Open graphs 2
                                          else if (snapshot.data[index].category
                                                  .toString() ==
                                              "2") {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GraphsTwo(valueToPassDb,
                                                            valueToPassText)));
                                          }
                                        },
                                        child: Icon(
                                          Icons.graphic_eq,
                                          size: 24.0,
                                        ))),
                                Flexible(
                                    child: FlatButton(
                                        color: Colors.transparent,
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.edit,
                                          size: 24.0,
                                        )))
                              ]),
                            ),
                          ),
                        ),
                      );
                    }));
          }
        },
      ),
    );
  }
}

Future? _fetchList() async {
  var result = await DBHelper.getList();
  print(result.toString());
  return result;
}
