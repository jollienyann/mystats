import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';

import '../home_page.dart';

class IntroPageThree extends StatefulWidget {
  @override
  _IntroPageThree createState() => _IntroPageThree();
}

class _IntroPageThree extends State<IntroPageThree> {
  List<ListObject> listObjects = [
    new ListObject("1","Meal","v1","2","1"),
    new ListObject("2","Sport","v2","2","1"),
    new ListObject("3","Sleep","v3","1","1"),
    new ListObject("4","Stress","v4","1","1"),
    new ListObject("5","Mood","v5","1","1"),
    new ListObject("6","Smoke","v6","2","1"),
  ];

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 50,
            mainAxisSpacing: 20),
        itemCount: listObjects.length,
        itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                  onPressed: () {
                    DBHelper.saveListObject(listObjects[index]);
                    setState(() {
                      listObjects.remove(listObjects[index]);
                    });
                  },
                  icon: Icon( // <-- Icon
                    Icons.sports_basketball,
                    size: 80.0,
                  ),
                  label: Text(listObjects[index].textValue.toString()))
              ,
            );
        });
  }
}