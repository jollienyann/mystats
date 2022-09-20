import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';

import '../home_page.dart';

class IntroPageThree extends StatefulWidget {
  @override
  _IntroPageThree createState() => _IntroPageThree();
}

class _IntroPageThree extends State<IntroPageThree> {
  List<ListObject> listObjects = [
    new ListObject("1", "Meal", "v1", "2", "0xe43b", "0", null),
    new ListObject("2", "Sport", "v2", "2", "0xe5e6", "0", null),
    new ListObject("3", "Sleep", "v3", "1", "0xe065", "0", null),
    new ListObject("4", "Stress", "v4", "1", "0xe6cc", "0", null),
    new ListObject("5", "Mood", "v5", "1", "0xe3fe", "0", null),
    new ListObject("6", "Smoke", "v6", "2", "0xe5c7", "0", null),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
          padding: EdgeInsets.only(top: 100),
          child: Text("Please select items you want to track")),
      GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 4 / 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 2),
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
                  icon: Icon(
                    // <-- Icon
                    IconData(int.parse(listObjects[index].icon.toString()), fontFamily: 'MaterialIcons'),
                    size: 80.0,
                  ),
                  label: Text(listObjects[index].textValue.toString())),
            );
          })
    ]);
  }
}
