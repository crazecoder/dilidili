import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dilidili/lib/library.dart';
import 'package:dilidili/utils/my_print.dart';

class DbHelper {
  Database db;
  static final DbHelper _dbHelper = DbHelper._internal();

  final String tableName = "cartoon";
  final String columnId = "cartoon_id";
  final String columnName = "cartoon_name";
  final String columnPicture = "cartoon_picture";
  final String columnUrl = "cartoon_url";
  final String columnEpisode = "cartoon_episode";

  factory DbHelper(){
    return _dbHelper;
  }

  DbHelper._internal();

  Future _initDataBase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = "${documentsDirectory.path}/demo.db";
      bool exists = await new File(path).exists();
      // On first install, copy database out of assets and into documents dir

      if (!exists) {
        ByteData data = await rootBundle.load("assets/demo.db");
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await new File(path).writeAsBytes(bytes);
      }
      db = await openDatabase(path, version: 1);
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName ($columnId INTEGER PRIMARY KEY, $columnName TEXT,$columnPicture TEXT, $columnUrl TEXT, $columnEpisode TEXT)");
    } catch (e) {
      print(e);
    }
  }

  Future<List<Cartoon>> getCartoon() async {
    await _initDataBase();
    List<Map> maps = await db.query(tableName);
    var cartoons = <Cartoon>[];
    if (maps.length > 0) {
      maps.forEach((map) {
        Cartoon cartoon = new Cartoon(
            url: map[columnUrl],
            name: map[columnName],
            picture: map[columnPicture],
            episode: map[columnEpisode]);
        cartoons.add(cartoon);
      });
    }
    return cartoons;
  }

  Future insertCartoon(Cartoon cartoon, InsertCallback callback) async {
    await _initDataBase();
    Map<String, String> map = {
      columnName: cartoon.name,
      columnPicture: cartoon.picture,
      columnUrl: cartoon.url,
      columnEpisode: cartoon.episode
    };
    try {
      List<Map> maps = await db.query(tableName,
          columns: [columnUrl],
          where: "$columnUrl = ?",
          whereArgs: [cartoon.url]);
      if (maps.isNotEmpty) {
        await db.update(tableName, map);
      } else {
        await db.insert(tableName, map);
      }
      callback();
    } catch (e) {
      print(e);
    }
  }

  Future close() async => db.close();
}

typedef void InsertCallback();
