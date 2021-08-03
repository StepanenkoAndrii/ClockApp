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

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  var _hours = 0;
  var _minutes = 0;
  var _seconds = 0;
  var _started = true;
  var _stopped = true;
  var _timeForTimer = 0;
  var _timerIsWorking = false;
  CountDownController _controller = CountDownController();
  var _visible = false;
  var _counter = 0;

  void startTimer() {
    setState(() {
      _counter++;
      _started = true;
      _stopped = false;
      _timerIsWorking = true;
      _visible = true;
    });
    if (_timeForTimer < 1)
      _timeForTimer = _hours * 3600 + _minutes * 60 + _seconds;
    if (_counter == 1)
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
            if (_timeForTimer < 1 || !_timerIsWorking) {
              if (_timeForTimer < 1) _visible = false;
              timer.cancel();
              _started = false;
              _stopped = true;
            } else {
              _timeForTimer -= 1;
            }
          },
        );
      },
    );
  }

  void stopTimer() {
    setState(() {
      _started = false;
      _stopped = true;
      _timerIsWorking = false;
      _visible = true;
    });
    _controller.pause();
  }

  void resetTimer() {
    setState(() {
      _started = false;
      _stopped = true;
      _timerIsWorking = false;
      _timeForTimer = 0;
      _visible = false;
    });
  }

  @override
  void initState() {
    initializeSetting();
    tz.initializeTimeZones();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Timer",
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
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
                        value: _hours,
                        minValue: 0,
                        maxValue: 23,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value > 0)
                                _started = false;
                              else
                                _started = true;
                              _hours = value;
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
                        value: _minutes,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value > 0)
                                _started = false;
                              else
                                _started = true;
                              _minutes = value;
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
                        value: _seconds,
                        minValue: 0,
                        maxValue: 59,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value > 0)
                                _started = false;
                              else
                                _started = true;
                              _seconds = value;
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
                    duration: _timeForTimer,
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
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _started ? null : startTimer,
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
                        color: _started ? Colors.grey[800] : Colors.white,
                        size: 80,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _stopped ? null : stopTimer,
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
                        color: _stopped ? Colors.grey[800] : Colors.white,
                        size: 80,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: _timeForTimer > 0 ? resetTimer : null,
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
                      color: _timeForTimer > 0 ? Colors.white : Colors.black,
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

Future<void> timerNotification() async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Timer',
      'Time has gone',
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
