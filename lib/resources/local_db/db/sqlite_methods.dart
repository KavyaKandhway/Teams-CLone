import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:teams_clone/models/log.dart';
import 'package:teams_clone/resources/local_db/interface/log_interface.dart';

class SqliteMethods implements LogInterface {
  Database? _db;

  String databaseName = "LogDB";

  String tableName = "Call_Logs";

  String id = 'log_id';
  String callerName = 'caller_name';
  String callerPic = 'caller_pic';
  String receiverName = 'receiver_name';
  String receiverPic = 'receiver_pic';
  String callStatus = 'call_status';
  String timestamp = 'timestamp';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    print("db was null, now awaiting it");
    _db = await init();
    print(_db);
    return _db!;
  }

  @override
  openDb(dbName) {
    // TODO: implement openDb
    databaseName = dbName;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    print(dir);
    String path = join(dir.path, databaseName);
    print("path= " + path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print(db);

    return db;
  }

  _onCreate(Database db, int version) async {
    print("here on create");
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";

    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    print(dbClient);
    await dbClient.insert(tableName, log.toMap(log));
    print("=====================================================");
    print("successfully added");
    print("=====================================================");
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$id = ?', whereArgs: [logId + 1]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;

    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
        ],
      );

      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
