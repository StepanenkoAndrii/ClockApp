import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  var hours = 0;
  var minutes = 0;
  var seconds = 0;
  var started = false;
  var stopped = true;
  var timeForTimer = 0;
  // var timeToDisplay = '';
  var timerIsWorking = false;
  CountDownController _controller = CountDownController();
  var _visible = false;
  var counter = 0;

  void startTimer() {
    setState(() {
      counter++;
      started = true;
      stopped = false;
      timerIsWorking = true;
      _visible = true;
    });
    if (timeForTimer < 1) timeForTimer = hours * 3600 + minutes * 60 + seconds;
    if (counter == 1)
      _controller.start();
    else
      _controller.resume();
    Timer.periodic(
      Duration(
        seconds: 1,
      ),
      (Timer timer) {
        setState(
          () {
            // if (mounted) {
            if (timeForTimer < 1 || !timerIsWorking) {
              if (timeForTimer < 1) _visible = false;
              timer.cancel();
              started = false;
              stopped = true;
            } else {
              timeForTimer -= 1;
            }
            // }
          },
        );
      },
    );
  }

  void stopTimer() {
    setState(() {
      started = false;
      stopped = true;
      timerIsWorking = false;
      _visible = true;
    });
    _controller.pause();
  }

  void resetTimer() {
    setState(() {
      started = false;
      stopped = true;
      timerIsWorking = false;
      timeForTimer = 0;
      _visible = false;
    });
  }

  String normalTimeDisplay(int timeForTimer) {
    int hours, minutes, seconds;
    String hoursStr, minutesStr, secondsStr;

    hours = timeForTimer ~/ 3600;
    timeForTimer -= hours * 3600;
    minutes = timeForTimer ~/ 60;
    seconds = timeForTimer - minutes * 60;

    if (hours < 10)
      hoursStr = '0' + hours.toString();
    else
      hoursStr = hours.toString();
    if (minutes < 10)
      minutesStr = '0' + minutes.toString();
    else
      minutesStr = minutes.toString();
    if (seconds < 10)
      secondsStr = '0' + seconds.toString();
    else
      secondsStr = seconds.toString();

    return hoursStr + " : " + minutesStr + " : " + secondsStr;
  }

  @override
  void initState() {
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !_visible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "HH",
                          style: GoogleFonts.acme(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      NumberPicker(
                        textStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 24,
                          ),
                        ),
                        selectedTextStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                        value: hours,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (value) {
                          setState(
                            () {
                              hours = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !_visible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "MM",
                          style: GoogleFonts.acme(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      NumberPicker(
                        textStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 24,
                          ),
                        ),
                        selectedTextStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                        value: minutes,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) {
                          setState(
                            () {
                              minutes = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !_visible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "SS",
                          style: GoogleFonts.acme(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      NumberPicker(
                        textStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 24,
                          ),
                        ),
                        selectedTextStyle: GoogleFonts.acme(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                          ),
                        ),
                        value: seconds,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) {
                          setState(
                            () {
                              seconds = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: CircularCountDownTimer(
                    backgroundColor: Colors.transparent,
                    fillColor: Colors.white,
                    ringColor: Colors.grey[800],
                    duration: timeForTimer,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.5,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 16,
                    // onStart: () {},
                    onComplete: () {
                      timerNotification();
                      resetTimer();
                    },
                    controller: _controller,
                    isTimerTextShown: true,
                    isReverse: true,
                    textFormat: CountdownTextFormat.HH_MM_SS,
                    textStyle: GoogleFonts.acme(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Text(
          //     normalTimeDisplay(timeForTimer),
          //     style: GoogleFonts.acme(
          //       textStyle: TextStyle(
          //         color: Colors.white,
          //         fontSize: 48,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: started ? null : startTimer,
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.play_circle_outline,
                        color: started ? Colors.grey[800] : Colors.white,
                        size: 80,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: stopped ? null : stopTimer,
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        Icons.pause_circle_outline,
                        color: stopped ? Colors.grey[800] : Colors.white,
                        size: 80,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: timeForTimer > 0 ? resetTimer : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey[800],
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 6,
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.grey[700],
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.acme(
                      color: timeForTimer > 0 ? Colors.white : Colors.black,
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     timerNotification();
          //     Timer(
          //       Duration(seconds: 5),
          //       () {
          //         showDialog(
          //           context: context,
          //           builder: (context) {
          //             return AlertDialog(
          //               title: Text("Time has ended"),
          //               content: Text("Timer has been stopped"),
          //               actions: [
          //                 TextButton(
          //                   onPressed: () => Navigator.pop(context),
          //                   child: Text("OK"),
          //                 ),
          //               ],
          //             );
          //           },
          //         );
          //       },
          //     );
          //   },
          //   child: Text(
          //     "Press",
          //     style: TextStyle(
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

Future<void> timerNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Timer',
      'Time has gone',
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      tz.TZDateTime.now(tz.local).add(
        const Duration(milliseconds: 100),
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description'),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);
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
