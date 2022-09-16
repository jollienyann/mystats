import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sam/db/database.dart';

class Graphs extends StatefulWidget {

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  Map<String, double> dataMap = {
    "Yes": 0,
    "No": 0,
  };
  late Future? _myString;
  // Initial Selected Value
  String dropdownvalue = 'Item 1';
  String value1="";
  String value2="";
  int index = 0;

  @override
  void initState() {
    super.initState();
    _myString = _fetchDataCategoryTwo();
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
                future: _myString,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    for(int i = 0 ; i < snapshot.data.length ; i++){
                      items.add(snapshot.data[i].dbValue.toString());
                    }
                    return DropdownButton(
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          index = items.indexOf(newValue.toString());
                          value1 = snapshot.data[index].valuesStats1;
                          value2 = snapshot.data[index].valuesStats2;
                          dataMap = {
                            "Yes": double.parse(value1),
                            "No": double.parse(value2),
                          };
                          dropdownvalue = newValue!;
                        });
                      },
                    );
                  }
                  return Container();
                }
            ),
            PieChart(dataMap: dataMap),
            ],
        )
      ),
    );
  }

  Future? _fetchDataCategoryTwo() async {
    var result = await DBHelper.getItemsCategoryTwo();
    List<Data> values = [];
    for(int i = 0 ; i < result.length; i++){
      var valuesStats = await DBHelper.getDataCategoryTwo(result[i]['dbValue'].toString());
      var valuesTitle = await DBHelper.getTitleCategry2(result[i]['dbValue'].toString());
      values.add(Data(result[i]['dbValue'],valuesStats[0]['Stats'].toString(),valuesStats[1]['Stats'].toString()));
      //values.add();
    }
    for(int j = 0 ; j < values.length;j++){
      print(values[j].dbValue.toString()+" "+values[j].valuesStats1.toString()+" "+values[j].valuesStats2.toString());
    }
    return values;
  }
}

class Data {
  String? dbValue;
  String? valuesStats1;
  String? valuesStats2;

  Data(this.dbValue,this.valuesStats1,this.valuesStats2);
}