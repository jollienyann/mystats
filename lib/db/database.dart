import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class DBHelper {

  static Future<Database> db() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "stats.db");
    print(path);
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        await createDatbase(database);
      },
    );
  }

  static Future<void> createDatbase(Database db) async {
    // When creating the db, create the table
    final now = new DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    await db.execute(
        "CREATE TABLE Stats("
            " id INTEGER PRIMARY KEY,"
            " createdAt TEXT DEFAULT CURRENT_TIMESTAMP,"
            " myDay TEXT,"
            " hangoverNight TEXT,"
            " alcool TEXT,"
            " sportMore1 TEXT,"
            " sleepMore8 TEXT,"
            " nap TEXT,"
            " reallySick TEXT,"
            " headache TEXT,"
            " workMore4 TEXT )");
    await db.execute(
        "CREATE TABLE ListObject("
            " id INTEGER PRIMARY KEY,"
            " textValue TEXT,"
            " dbValue TEXT,"
            " icon TEXT )");
    print("Tables created");
  }

  static Future<void> saveListObject() async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO ListObject (textValue,dbValue,icon)VALUES(My Day,myDac,)');
    });
  }

  static Future<void> saveStats(String toInsert, String value) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Stats ($toInsert)VALUES($value)');
    });
  }

  static Future<void> updateStats(String toUpdate, String value) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE Stats SET ${toUpdate} = ?',[value]);
    });
  }

  static Future<dynamic> getStats(String date, String toGet) async {
    var dbClient = await db();
    return await dbClient.rawQuery('SELECT ${toGet} FROM Stats WHERE createdAt = ${date}');
  }

  static Future<dynamic> getDate(String date) async {
    var dbClient = await db();
    return await dbClient.rawQuery('SELECT createdAt FROM Stats WHERE createdAt like ?',[date+"%"]);
  }







}