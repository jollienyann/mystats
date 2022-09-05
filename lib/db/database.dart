import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sam/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class DBHelper {

  //Initiate db
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

  //Create the database
  static Future<void> createDatbase(Database db) async {
    // When creating the db, create the table
    final now = new DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    await db.execute(
        "CREATE TABLE Stats("
            " id INTEGER PRIMARY KEY,"
            " createdAt TEXT DEFAULT CURRENT_TIMESTAMP,"
            " v1 TEXT,"
            " v2 TEXT,"
            " v3 TEXT,"
            " v4 TEXT,"
            " v5 TEXT,"
            " v6 TEXT,"
            " v7 TEXT,"
            " v8 TEXT,"
            " v9 TEXT )");
    await db.execute(
        "CREATE TABLE ListObject("
            " textValue TEXT,"
            " dbValue TEXT,"
            " category TEXT,"
            " icon TEXT,"
            " doneToday TEXT)");
    print("Tables created");
  }

  //Add new item to list
  static Future<void> saveListObject(ListObject object) async {
    String toInsert = object.textValue.toString();
    String value = object.dbValue.toString();
    String category = object.category.toString();
    String icon = object.icon.toString();
    String doneToday = object.doneToday.toString();

    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO ListObject (textValue,dbValue,category,icon,doneToday)VALUES("$toInsert","$value","$category","$icon","$doneToday")');
    });
  }

  //Save a daily stat
  static Future<void> saveStats(String toInsert, String value) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Stats ($toInsert)VALUES($value)');
    });
  }

  //Update stats if already an entry for today
  static Future<void> updateStats(String toUpdate, String value) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE Stats SET ${toUpdate} = ?',[value]);
    });
  }

  //Get all stats
  static Future<dynamic> getStats(String date, String toGet) async {
    var dbClient = await db();
    return await dbClient.rawQuery('SELECT ${toGet} FROM Stats WHERE createdAt = ${date}');
  }

  //Get date for today
  static Future<dynamic> getDate(String date) async {
    var dbClient = await db();
    return await dbClient.rawQuery('SELECT createdAt FROM Stats WHERE createdAt like ?',[date+"%"]);
  }

  //Get list of object
  static Future<List<ListObject>> getList() async {
    // Get a reference to the database.
    var dbClient = await db();

    // Query the table for all The Objects.
    final List<Map<String, dynamic>> maps = await dbClient.query('ListObject');

    // Convert the List<Map<String, dynamic> into a List<ListObject>.
    return List.generate(maps.length, (i) {
      return ListObject(
        maps[i]['id'],
        maps[i]['textValue'],
        maps[i]['dbValue'],
        maps[i]['category'],
        maps[i]['icon'],
        maps[i]['doneToday']
        // Same for the other properties
      );
    });
  }

  //Update daily done
  static Future<void> updateObject(String toUpdate) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE ListObject SET doneToday = "1" Where dbValue = "$toUpdate"');
    });
  }


}