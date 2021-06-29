import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:start_app/clock_page.dart';
import 'package:start_app/data.dart';
import 'package:start_app/enums.dart';
import 'package:start_app/stopwatch_page.dart';
import 'package:start_app/time_info.dart';
import 'package:start_app/timer_page.dart';
// import 'package:start_app/variables.dart';

import 'alarm_page.dart';
import 'menu_info.dart';

Widget uploadPage(BuildContext context, MenuInfo data) {
  switch (data.menuType) {
    case MenuType.clock:
      return ClockPage();
    case MenuType.alarm:
      return AlarmPage();
    case MenuType.timer:
      return TimerPage();
    case MenuType.stopwatch:
      return StopwatchPage();
    default:
      return null;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        var currentTimeInfo = Provider.of<TimeInfo>(context, listen: false);
        currentTimeInfo.updateCurrentTime();
      },
    );
    super.initState();
  }

  MenuType menuTypeVar;
  var timeBuffer = 0;
  final List<Widget> menuTypesList = <Widget>[
    ClockPage(),
    AlarmPage(),
    TimerPage(),
    StopwatchPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Container(
        padding: EdgeInsets.fromLTRB(32, 64, 32, 8),
        child: Consumer<MenuInfo>(
          builder: (context, data, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onHorizontalDragEnd: (DragEndDetails details) {
                //     if (details.primaryVelocity > 0) {
                //       print('yee');
                //       menuTypeVar = MenuType.alarm;
                //     } else if (details.primaryVelocity < 0) {
                //       print('yee2');
                //       menuTypeVar = MenuType.alarm;
                //     }
                //   },
                //   child: uploadPage(context, data),
                // ),
                uploadPage(context, data),

                // Container(
                //   height: MediaQuery.of(context).size.height * 0.82,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     // physics: NeverScrollableScrollPhysics(),
                //     itemCount: 4,
                //     itemBuilder: (context, index) {
                //       return Container(
                //         // color: Colors.lightGreen[50],
                //         height: MediaQuery.of(context).size.height * 0.82,
                //         width: MediaQuery.of(context).size.width * 0.85,
                //         child: Opacity(
                //           // opacity: clockVisible ? 1 : 0,
                //           opacity: 1,
                //           child: menuTypesList[index],
                //         ),
                //       );
                //     },
                //     children: [
                //       Container(
                //         color: Colors.lightGreen,
                //         height: MediaQuery.of(context).size.height * 0.82,
                //         width: MediaQuery.of(context).size.width * 0.85,
                //         child: Opacity(
                //           opacity: clockVisible ? 1 : 0,
                //           child: ClockPage(),
                //         ),
                //       ),
                //       Container(
                //         color: Colors.lightBlue,
                //         height: MediaQuery.of(context).size.height * 0.82,
                //         width: MediaQuery.of(context).size.width * 0.85,
                //         child: Opacity(
                //           opacity: alarmVisible ? 1 : 0,
                //           child: AlarmPage(),
                //         ),
                //       ),
                //       Container(
                //         color: Colors.yellow,
                //         height: MediaQuery.of(context).size.height * 0.82,
                //         width: MediaQuery.of(context).size.width * 0.85,
                //         child: Opacity(
                //           opacity: timerVisible ? 1 : 0,
                //           child: TimerPage(),
                //         ),
                //       ),
                //       Container(
                //         color: Colors.pink,
                //         height: MediaQuery.of(context).size.height * 0.82,
                //         width: MediaQuery.of(context).size.width * 0.85,
                //         child: Opacity(
                //           opacity: stopwatchVisible ? 1 : 0,
                //           child: StopwatchPage(),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.085,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: menuItems
                          .map((currentMenuInfo) =>
                              buildMenuButton(currentMenuInfo))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return SizedBox(
          height: 62,
          child: TextButton(
            onPressed: () {
              var menuInfo = Provider.of<MenuInfo>(context, listen: false);
              menuInfo.updateMenu(currentMenuInfo);
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                currentMenuInfo.menuType == value.menuType
                    ? Colors.grey[800]
                    : Colors.transparent,
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.grey[700],
              ),
            ),
            child: Column(
              children: [
                currentMenuInfo.icon,
                Text(
                  currentMenuInfo.title ?? '',
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
