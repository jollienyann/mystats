import 'package:flutter/material.dart';
import 'package:sam/db/database.dart';

import '../home_page.dart';

class IntroPageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
          child: ElevatedButton.icon(
            onPressed: () {
              ListObject lo = new ListObject();
              lo.textValue = "v1";
              lo.dbValue = "Meal";
              lo.category = "1";
              lo.icon = "1";
              DBHelper.saveListObject(lo);
            },
            icon: Icon( // <-- Icon
              Icons.no_meals,
              size: 24.0,
            ),
            label: Text('Meal'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[200],
          child: ElevatedButton.icon(
            onPressed: () {
              ListObject lo = new ListObject();
              lo.textValue = "v2";
              lo.dbValue = "Sport";
              lo.category = "1";
              lo.icon = "1";
              DBHelper.saveListObject(lo);
            },
            icon: Icon( // <-- Icon
              Icons.sports_basketball,
              size: 24.0,
            ),
            label: Text('Sport'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[300],
            child: ElevatedButton.icon(
              onPressed: () {
                ListObject lo = new ListObject();
                lo.textValue = "v3";
                lo.dbValue = "Sleep";
                lo.category = "1";
                lo.icon = "1";
                DBHelper.saveListObject(lo);
              },
              icon: Icon( // <-- Icon
                Icons.alarm,
                size: 24.0,
              ),
              label: Text('Sleep'),
            ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[400],
          child: ElevatedButton.icon(
            onPressed: () {
              ListObject lo = new ListObject();
              lo.textValue = "v4";
              lo.dbValue = "Stress";
              lo.category = "1";
              lo.icon = "1";
              DBHelper.saveListObject(lo);
            },
            icon: Icon( // <-- Icon
              Icons.warning,
              size: 24.0,
            ),
            label: Text('Stress'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[500],
            child: ElevatedButton.icon(
              onPressed: () {
                ListObject lo = new ListObject();
                lo.textValue = "v5";
                lo.dbValue = "Sleep";
                lo.category = "1";
                lo.icon = "1";
                DBHelper.saveListObject(lo);
              },
              icon: Icon( // <-- Icon
                Icons.snooze,
                size: 24.0,
              ),
              label: Text('Sleep'),
            ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[600],
            child: ElevatedButton.icon(
              onPressed: () {
                ListObject lo = new ListObject();
                lo.textValue = "v6";
                lo.dbValue = "Mood";
                lo.category = "1";
                lo.icon = "1";
                DBHelper.saveListObject(lo);
              },
              icon: Icon( // <-- Icon
                Icons.mood_bad,
                size: 24.0,
              ),
              label: Text('Mood'),
            ),
        ),
      ],
    );
  }

}