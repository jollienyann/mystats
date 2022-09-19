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
            " doneToday TEXT,"
            " doneDate TEXT)");
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
  static Future<void> updateStats(String toUpdate, String value,String date) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE Stats SET "${toUpdate}" = "${value}" where createdAt like "${date}"');
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

  //Gest last insert
  static Future<dynamic> getLastDate() async {
    var dbClient = await db();
    return await dbClient.rawQuery('SELECT createdAt FROM Stats WHERE Id = (SELECT MAX(Id) FROM Stats)');
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
        maps[i]['doneToday'],
        maps[i]['doneDate']
        // Same for the other properties
      );
    });
  }

  //Update ListObject if done today
  static Future<void> updateObject(String value,String date,String toUpdate) async {
    var dbClient = await db();
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE ListObject SET doneToday = "${value}", doneDate = "${date}" Where dbValue = "$toUpdate"');
    });
  }

  //Get items from category 2
  static Future getItemsCategoryTwo() async {
    var dbClient = await db();
    List<Map> result =  await dbClient.rawQuery('select dbValue, textValue from ListObject where category = 2');
    return result;
  }

  //Get items from category 1
  static Future getItemsCategoryOne() async {
    var dbClient = await db();
    List<Map> result =  await dbClient.rawQuery('select dbValue, textValue from ListObject where category = 1');
    return result;
  }

  //Get data from items category 2
  static Future<dynamic> getDataCategoryTwo(String dbValue) async {
    var dbClient = await db();
    return await dbClient.rawQuery('Select Count("${dbValue}") as "Stats" from Stats where "${dbValue}" = 2 UNION ALL Select Count("${dbValue}") from Stats where "${dbValue}" = 1');
  }

  //Get data from items category 1
  static Future<dynamic> getDataCategoryOne(String dbValue) async {
    var dbClient = await db();
    return await dbClient.rawQuery('Select Count("${dbValue}") as "Stats" from Stats where "${dbValue}" = 1 UNION ALL Select Count("${dbValue}") from Stats where "${dbValue}" = 2 UNION ALL Select Count("${dbValue}") from Stats where "${dbValue}" = 3 UNION ALL Select Count("${dbValue}") from Stats where "${dbValue}" = 4 UNION ALL Select Count("${dbValue}") from Stats where "${dbValue}" = 5');
  }

}