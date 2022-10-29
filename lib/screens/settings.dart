import 'dart:io';
import 'dart:typed_data';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sam/db/database.dart';

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
  String message = '';
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
        ElevatedButton(
          onPressed: () async {
            var status = await Permission.storage.status;
            if (status.isDenied) {
              await Permission.storage.request();
              return;
            }
            print(status);
            File file = await DBHelper.writeDBFileToDownloadFolder();
            if (await file.length() > 0) {
              Fluttertoast.showToast(
                  msg: "Exported",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
          child: const Text('Backup Db'),
        ),
            ElevatedButton(
              onPressed: () async {
                var status = await Permission.storage.status;
                if (status.isDenied) {
                  await Permission.storage.request();
                  return;
                }
                print(status);
                await DBHelper.importDatabase();
              },
              child: const Text('Restore Db'),
            )
  ]
        ),
      ),
    );
  }

}