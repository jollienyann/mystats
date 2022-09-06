import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';

class Graphs extends StatefulWidget {

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  Map<String, double> dataMap = {
    "Smoke": 5,
    "No smoke": 3,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: PieChart(dataMap: dataMap),
    );
  }
}