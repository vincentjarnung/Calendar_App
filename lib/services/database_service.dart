import 'package:calendar_app/models/activity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableName = 'activities';
final String id = 'id';
final String year = 'year';
final String month = 'month';
final String day = 'day';
final String title = 'title';
final String info = 'info';
final String startTime = 'startTime';
final String endTime = 'endTime';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    if (_db == null) _db = await initializeDatabase();
    return _db!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + 'calendar.db';
    print('initializing');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' 
        CREATE TABLE IF NOT EXISTS $tableName (
          $id INTEGER PRIMARY KEY AUTOINCREMENT,
          $year INTEGER NOT NULL,
          $month INTEGER NOT NULL,
          $day INTEGER NOT NULL,
          $title TEXT NOT NULL,
          $info TEXT NOT NULL,
          $startTime TEXT NOT NULL,
          $endTime TEXT NOT NULL)
        ''').then((value) => print('tableCreated'));
      },
    );
    return database;
  }

  void insertAlarm(ActivityModel activityModel) async {
    var db = await this.database;
    var result = await db.insert(tableName, activityModel.toMap());
    print(result);
  }

  Future<int> delete(int id) async {
    print(id);
    var db = await this.database;
    var result = await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    print('$result is deleted');
    return result;
  }

  Future<List<ActivityModel>> getMonthlyActivities(
      String searchYear, String searchMonth) async {
    List<ActivityModel> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableName,
        where: "$year = $searchYear AND $month == $searchMonth");
    result.forEach((element) {
      var alarmModel = ActivityModel.fromMap(element);
      _alarms.add(alarmModel);
    });
    return _alarms;
  }

  Future<List<ActivityModel>> getAllActivities() async {
    List<ActivityModel> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableName);
    result.forEach((element) {
      var alarmModel = ActivityModel.fromMap(element);
      _alarms.add(alarmModel);
    });
    return _alarms;
  }

  Future<int> getNum(
      String searchYear, String searchMonth, String searchDay) async {
    var db = await this.database;
    var result = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableName WHERE $year = $searchYear AND $month == $searchMonth AND $day == $searchDay'));

    print(result.toString() + '  num');

    return result!;
  }
}
