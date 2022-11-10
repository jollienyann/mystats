import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sam/db/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:intl/intl.dart";

class GraphsOne extends StatefulWidget {
  String dbValue;
  String textValue;

  GraphsOne(this.dbValue,this.textValue);

  @override
  State<GraphsOne> createState() => _GraphsOneState(dbValue,textValue);
}

class _GraphsOneState extends State<GraphsOne> {
  String dbValue;
  String textValue;

  _GraphsOneState(this.dbValue,this.textValue);

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
  String dropdownvalue = '';
  String value1 = "";
  String value2 = "";
  String value3 = "";
  String value4 = "";
  String value5 = "";

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
          child: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: _myStringOne,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    value1 = snapshot.data[index].valuesStats1;
                    value2 = snapshot.data[index].valuesStats2;
                    value3 = snapshot.data[index].valuesStats3;
                    value4 = snapshot.data[index].valuesStats4;
                    value5 = snapshot.data[index].valuesStats5;

                    print(value1 + value2 + value3 + value4 + value5);

                    chartData = [
                      ChartData(1, double.parse(value1)),
                      ChartData(2, double.parse(value2)),
                      ChartData(3, double.parse(value3)),
                      ChartData(4, double.parse(value4)),
                      ChartData(5, double.parse(value5))
                    ];
                  }
                  return Container(
                    child: Flexible(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20) ,
                            child: Text(textValue,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SfCircularChart(
                              legend: Legend(isVisible: true,borderColor: Colors.black, borderWidth: 2),
                              series: <CircularSeries>[
                                // Render pie chart
                                PieSeries<ChartData, String>(
                                    dataSource: chartData,
                                    pointColorMapper:(ChartData data,  _) => data.color,
                                    xValueMapper: (ChartData data, _) => data.x.toString(),
                                    yValueMapper: (ChartData data, _) => data.y,
                                    dataLabelSettings: DataLabelSettings(
                                      // Renders the data label
                                        isVisible: true
                                    )
                                )
                              ]
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      )),
    );
  }

  Future? _fetchDataCategoryOne() async {
    var result = await DBHelper.getItemsCategoryOne();
    List<DataOne> values = [];
    for (int i = 0; i < result.length; i++) {
      var valuesStats = await DBHelper.getDataCategoryOne(dbValue);
      values.add(DataOne(
          result[i]['dbValue'],
          result[i]['textValue'],
          valuesStats[0]['Stats'].toString(),
          valuesStats[1]['Stats'].toString(),
          valuesStats[2]['Stats'].toString(),
          valuesStats[3]['Stats'].toString(),
          valuesStats[4]['Stats'].toString()));
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

  DataOne(this.dbValue, this.textValue, this.valuesStats1, this.valuesStats2,
      this.valuesStats3, this.valuesStats4, this.valuesStats5);
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final int x;
  final double y;
  final Color? color;
}
