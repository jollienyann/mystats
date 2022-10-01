import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sam/db/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphsTwo extends StatefulWidget {
  String dbValue;
  String textValue;

  GraphsTwo(this.dbValue,this.textValue);
  @override
  State<GraphsTwo> createState() => _GraphsTwoState(dbValue,textValue);
}

class _GraphsTwoState extends State<GraphsTwo> {
  String dbValue;
  String textValue;

  _GraphsTwoState(this.dbValue,this.textValue);
  List<ChartData> chartData = [
    ChartData('Yes', 0),
    ChartData('No', 0)
  ];
  late Future? _myString;
  bool show = false;
  int category = 0;
  // Initial Selected Value
  String dropdownvalue = '';
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
    List<String> itemsOne = [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: _myString,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      value1 = snapshot.data[index].valuesStats1;
                      value2 = snapshot.data[index].valuesStats2;
                      chartData = [
                        ChartData('Yes', double.parse(value1)),
                        ChartData('No', double.parse(value2))
                      ];
                      return Container(
                        child: Flexible(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20) ,
                                child: Text( textValue,
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
                                        xValueMapper: (ChartData data, _) => data.x,
                                        yValueMapper: (ChartData data, _) => data.y,
                                        dataLabelSettings: DataLabelSettings(
                                          // Renders the data label
                                            isVisible: true
                                        )
                                    )
                                  ]
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  }
              ),
              ],
          ),
        )
      ),
    );
  }

  Future? _fetchDataCategoryTwo() async {
    var result = await DBHelper.getItemsCategoryTwo();
    List<Data> values = [];
    for(int i = 0 ; i < result.length; i++){
      var valuesStats = await DBHelper.getDataCategoryTwo(dbValue);
      values.add(Data(result[i]['dbValue'],result[i]['textValue'],valuesStats[0]['Stats'].toString(),valuesStats[1]['Stats'].toString()));
      //values.add();
    }
    return values;
  }
}

class Data {
  String? dbValue;
  String? textValue;
  String? valuesStats1;
  String? valuesStats2;

  Data(this.dbValue,this.textValue,this.valuesStats1,this.valuesStats2);
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
