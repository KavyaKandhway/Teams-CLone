import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teams_clone/models/log.dart';
import 'package:teams_clone/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  String hiveBox = "";
  @override
  openDb(dbName) {
    // TODO: implement openDb
    hiveBox = dbName;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async {
    print("here add log hive");
    var box = await Hive.openBox(hiveBox);

    var logMap = log.toMap(log);

    int idOfInput = await box.add(logMap);

    close();
    print("log added");
    return idOfInput;
  }

  updateLogs(int i, Log newLog) async {
    var box = await Hive.openBox(hiveBox);

    var newLogMap = newLog.toMap(newLog);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  Future<List<Log>> getLogs() async {
    var box = await Hive.openBox(hiveBox);

    List<Log> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);

      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hiveBox);

    await box.deleteAt(logId);
  }

  @override
  close() => Hive.close();
}
