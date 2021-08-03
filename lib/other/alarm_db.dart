import 'package:sqflite/sqflite.dart';
import 'package:start_app/other/alarm_info.dart';

final String _tableAlarm = 'alarm';
final String _columnId = 'id';
final String _columnDate = 'alarmDate';
final String _columnTime = 'alarmTime';

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

  //Database initialization
  Future<Database> initializeDatabase() async {
    var _dir = await getDatabasesPath();
    var _path = _dir + 'alarm.db';

    var database = openDatabase(_path, version: 1, onCreate: (db, version) {
      db.execute('''
        create table $_tableAlarm (
          $_columnId integer primary key autoincrement,
          $_columnDate text not null,
          $_columnTime text not null
        )
      ''');
    });
    return database;
  }

  // Add new alarm to database
  void insertAlarm(AlarmInfo alarmInfo) async {
    var _db = await this.database;
    await _db.insert(_tableAlarm, alarmInfo.toJson());
  }

  // Get all user alarms from database
  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];
    var _db = await this.database;
    var _result = await _db.query(_tableAlarm);
    _result.forEach((element) {
      var _alarmInfo = AlarmInfo.fromJson(element);
      _alarms.add(_alarmInfo);
    });
    return _alarms;
  }

  // Delete alarm from database
  Future<int> deleteAlarm(int id) async {
    var _db = await this.database;
    return await _db
        .delete(_tableAlarm, where: '$_columnId = ?', whereArgs: [id]);
  }
}
