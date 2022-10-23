import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/theme_provider.dart';

const List<Widget> themes = <Widget>[
  Text('Light'),
  Text('Dark')
];

class Settings extends StatefulWidget {

  @override
  State<Settings> createState() => _SettingsState();
}

class _Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text('Settings')
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 20,right: 10,bottom: 10),
        child: Column(
          children: [
            Text("Theme", style: TextStyle(fontSize: 20)),
            Switch.adaptive(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              final provider = Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            },
          ),
  ]
        ),
      ),
    );
  }
}