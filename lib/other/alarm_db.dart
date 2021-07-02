import 'package:sqflite/sqflite.dart';
import 'package:start_app/other/alarm_info.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnDate = 'alarmDate';
final String columnTime = 'alarmTime';

class AlarmDB {
  static Database _database;
  static AlarmDB _alarmDB;

  AlarmDB._createInstance();
  factory AlarmDB() {
    if (_alarmDB == null) {
      _alarmDB = AlarmDB._createInstance();
    }
    return _alarmDB;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    print(dir);
    var path = dir + 'alarm.db';

    var database = openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        create table $tableAlarm (
          $columnId integer primary key autoincrement,
          $columnDate text not null,
          $columnTime text not null
        )
      ''');
    });
    return database;
  }

  void insertAlarm(AlarmInfo alarmInfo) async {
    var db = await this.database;
    var result = await db.insert(tableAlarm, alarmInfo.toJson());
    print(result);
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];
    var db = await this.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromJson(element);
      _alarms.add(alarmInfo);
    });
    return _alarms;
  }

  Future<int> deleteAlarm(int id) async {
    var db = await this.database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
