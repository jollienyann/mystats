import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sam/db/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphsOne extends StatefulWidget {

  @override
  State<GraphsOne> createState() => _GraphsOneState();
}

class _GraphsOneState extends State<GraphsOne> {
  List<ChartData> chartData = [
    ChartData(1, 0),
    ChartData(2, 0),
    ChartData(3, 0),
    ChartData(4, 0),
    ChartData(5, 0)
  ];

  late Future? _myStringOne;
  bool show = false;
  int category = 0;
  // Initial Selected Value
  String dropdownvalue = 'Item 1';
  String value1="";
  String value2="";
  String value3="";
  String value4="";
  String value5="";

  int index = 0;

  @override
  void initState() {
    super.initState();
    _myStringOne = _fetchDataCategoryOne();
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
                future: _myStringOne,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    for(int i = 0 ; i < snapshot.data.length ; i++){
                      items.add(snapshot.data[i].textValue.toString());
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
                          show = true;
                          index = items.indexOf(newValue.toString());
                          value1 = snapshot.data[index].valuesStats1;
                          value2 = snapshot.data[index].valuesStats2;
                          value3 = snapshot.data[index].valuesStats3;
                          value4 = snapshot.data[index].valuesStats4;
                          value5 = snapshot.data[index].valuesStats5;

                          chartData = [
                            ChartData(1, double.parse(value1)),
                            ChartData(2, double.parse(value2)),
                            ChartData(3, double.parse(value3)),
                            ChartData(4, double.parse(value4)),
                            ChartData(5, double.parse(value5))
                          ];

                          dropdownvalue = newValue!;
                        });
                      },
                    );
                  }
                  return Container();
                }
            ),
            Text(dropdownvalue),
            show ? SfCartesianChart(
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<ChartData, int>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y
                  )
                ]
            ) : Text("Please select"),
            ],
        )
      ),
    );
  }

  Future? _fetchDataCategoryOne() async {
    var result = await DBHelper.getItemsCategoryOne();
    List<DataOne> values = [];
    for(int i = 0 ; i < result.length; i++){
      var valuesStats = await DBHelper.getDataCategoryOne(result[i]['dbValue'].toString());
      print(valuesStats[0]['Stats'].toString()+" "+valuesStats[1]['Stats'].toString()+" "+valuesStats[2]['Stats'].toString()+" "+valuesStats[3]['Stats'].toString()+" "+valuesStats[4]['Stats'].toString());
      values.add(DataOne(result[i]['dbValue'],result[i]['textValue'],valuesStats[0]['Stats'].toString(),valuesStats[1]['Stats'].toString(),valuesStats[2]['Stats'].toString(),valuesStats[3]['Stats'].toString(),valuesStats[4]['Stats'].toString()));
      //values.add();
    }
    return values;
  }
}

class DataOne {
  String? dbValue;
  String? textValue;
  String? valuesStats1;
  String? valuesStats2;
  String? valuesStats3;
  String? valuesStats4;
  String? valuesStats5;


  DataOne(this.dbValue,this.textValue,this.valuesStats1,this.valuesStats2,this.valuesStats3,this.valuesStats4,this.valuesStats5);
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}