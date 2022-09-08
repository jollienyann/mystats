import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sam/db/database.dart';

class Graphs extends StatefulWidget {

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: FutureBuilder(
        future: DBHelper.getLengthCategoryTwo(),
        builder: (context, AsyncSnapshot<dynamic> snapshotLength) {
          if (snapshotLength.hasData) {
            print("LENGTH "+snapshotLength.data[0].toString());
            //return Text(snapshot.data[0]['length'].toString());
            return FutureBuilder(
              future: DBHelper.getItemsCategoryTwo(),
                builder: (context, AsyncSnapshot<dynamic> snapshotItems) {
                  if(snapshotItems.hasData){
                    print(snapshotItems.data[0].toString());
                    for(int i = 0; i < int.parse(snapshotLength.data[0]['length'].toString()) ; i++){
                      return FutureBuilder(
                        future: DBHelper.getDataCategoryTwo(snapshotItems.data[i]["Category2"].toString()),
                          builder: (context, AsyncSnapshot<dynamic> snapshotData) {
                            if(snapshotData.hasData){
                              Map<String, double> dataMap = {
                                "No Smoke": double.parse(snapshotData.data[1]["Stats"].toString()),
                                "Smoke": double.parse(snapshotData.data[0]["Stats"].toString()),
                              };
                              print("PRINT "+snapshotData.data[1].toString());
                              return PieChart(
                                  dataMap: dataMap
                              );
                            }
                            return Text("Error loading data");
                          }
                      );
                    }
                    return Text("Error loading data");
                  }
                  return Text("Error loading data");
                }
            );
          }
          return Text("Error loading data");
        },
      )
    );
  }




}