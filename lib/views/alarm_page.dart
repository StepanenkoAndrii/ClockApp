// import 'package:day_night_time_picker/day_night_time_picker.dart';
// import 'package:day_night_time_picker/lib/constants.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:start_app/other/alarm_db.dart';
import 'package:start_app/other/alarm_info.dart';
// import 'package:start_app/variables.dart';
// import 'package:start_app/variables.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  // int workingAlarmsNum = 0;
  List<String> alarmTime = [];
  List<String> alarmDate = [];
  bool timeIsPicked = false;
  bool dateIsPicked = false;
  TimeOfDay pickedTime;
  DateTime pickedDate;
  bool alarmPicker = false;
  AlarmDB _alarmDB = AlarmDB();
  Future<List<AlarmInfo>> _alarms;

  @override
  void initState() {
    _alarmDB.initializeDatabase().then((value) {
      print("database initialized");
      loadAlarms();
    });
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmDB.getAlarms();
    if (mounted) setState(() {});
  }

  void deleteAlarmById(int id) {
    setState(() {
      cancelNotification(id);
      _alarmDB.deleteAlarm(id);
    });
  }

  void deleteAlarm(int id) {
    setState(() {
      _alarmDB.deleteAlarm(id);
    });
  }

  Future<int> getNewId() async {
    List<AlarmInfo> _alarmsList = await _alarms;
    if (_alarmsList.length > 0)
      return await _alarms.then((value) => value.last.id) + 1;
    return 1;
  }

  String getTextDate() {
    if (pickedDate == null)
      return 'Click to pick date';
    else
      return DateFormat('dd/MM/yyyy').format(pickedDate);
  }

  String getTextTime() {
    if (pickedTime == null)
      return 'Click to pick time';
    else {
      final hours = pickedTime.hour.toString().padLeft(2, '0');
      final minutes = pickedTime.minute.toString().padLeft(2, '0');
      return '$hours : $minutes';
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? initialDate,
      firstDate: DateTime(DateTime.now().month),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (newDate == null) return;
    setState(() {
      pickedDate = newDate;
      dateIsPicked = true;
    });
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final newTime = await showTimePicker(
      context: context,
      initialTime: pickedTime ?? initialTime,
    );
    if (newTime != null) {
      setState(() {
        timeIsPicked = true;
        pickedTime = newTime;
        // print("${pickedTime.toString()} + $timeIsPicked");
      });
      print(timeIsPicked);
    }
  }

  void changeAlarmStateToTrue() {
    setState(() {
      alarmPicker = true;
    });
  }

  void changeAlarmStateToFalse() {
    setState(() {
      alarmPicker = false;
    });
  }

  Future<bool> alarmsVisibility() async {
    List<AlarmInfo> _alarmsList = await _alarms;
    if (_alarmsList.length > 0) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Alarm",
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !alarmPicker,
            child: Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Current alarms",
                    style: GoogleFonts.acme(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: FutureBuilder<List<AlarmInfo>>(
                        future: _alarms,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                              children: snapshot.data.map<Widget>(
                                (alarm) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(16, 6, 0, 6),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(48),
                                      ),
                                      color: Colors.grey[800],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          alarm.alarmDate,
                                          style: GoogleFonts.acme(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          alarm.alarmTime,
                                          style: GoogleFonts.acme(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteAlarmById(alarm.id);
                                            loadAlarms();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Colors.transparent,
                                            ),
                                            padding: MaterialStateProperty.all<
                                                EdgeInsetsGeometry>(
                                              EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                            ),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                              Colors.grey[800],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          }
                          return Center(
                            child: Text(
                              "Loading...",
                              style: GoogleFonts.acme(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text(
                        "No current alarms",
                        style: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !alarmPicker,
            child: Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    changeAlarmStateToTrue();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.grey[800],
                    ),
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: alarmPicker,
            child: Flexible(
              fit: FlexFit.tight,
              flex: 7,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Text(
                        "Pick the time for your alarm",
                        style: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              pickDate(context);
                            },
                            child: Text(
                              getTextDate(),
                              style: GoogleFonts.acme(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey[800],
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 16,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Colors.grey[800],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pickTime(context);
                            },
                            child: Text(
                              getTextTime(),
                              style: GoogleFonts.acme(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey[800],
                              ),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 16,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              overlayColor: MaterialStateProperty.all(
                                Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                changeAlarmStateToFalse();
                              },
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            TextButton(
                              onPressed: () {
                                if (pickedDate != null && pickedTime != null) {
                                  changeAlarmStateToFalse();
                                  alarmTime.add(getTextTime());
                                  alarmDate.add(getTextDate());
                                  var futureDateTime = new DateTime(
                                          pickedDate.year,
                                          pickedDate.month,
                                          pickedDate.day,
                                          pickedTime.hour,
                                          pickedTime.minute)
                                      .millisecondsSinceEpoch;
                                  var currentDateTime = new DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          DateTime.now().hour,
                                          DateTime.now().minute)
                                      .millisecondsSinceEpoch;
                                  final duration =
                                      futureDateTime - currentDateTime;
                                  var newId = getNewId();
                                  alarmNotification(context, duration, newId);
                                  var alarmInfo = AlarmInfo(
                                      alarmDate: getTextDate(),
                                      alarmTime: getTextTime());
                                  _alarmDB.insertAlarm(alarmInfo);
                                  loadAlarms();
                                } else
                                  changeAlarmStateToFalse();
                              },
                              child: Text(
                                "OK",
                                style: GoogleFonts.acme(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> alarmNotification(context, int duration, Future<int> id) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      await id,
      'Alarm',
      'The time has come',
      tz.TZDateTime.now(tz.local).add(Duration(milliseconds: duration)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'full screen channel id',
        'full screen channel name',
        'full screen channel description',
        priority: Priority.high,
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('alarm_sound'),
        playSound: true,
      )),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> cancelNotification(id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> initializeSetting() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('timer_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    },
  );
}
