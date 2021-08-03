import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:start_app/views/clock_page.dart';
import 'package:start_app/other/data.dart';
import 'package:start_app/other/enums.dart';
import 'package:start_app/views/stopwatch_page.dart';
import 'package:start_app/other/time_info.dart';
import 'package:start_app/views/timer_page.dart';

import 'views/alarm_page.dart';
import 'other/menu_info.dart';

// Upload view page (clock, alarm, timer or stopwatch)
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

  // MenuType menuTypeVar;
  // var timeBuffer = 0;
  // final List<Widget> menuTypesList = <Widget>[
  //   ClockPage(),
  //   AlarmPage(),
  //   TimerPage(),
  //   StopwatchPage()
  // ];

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
                uploadPage(context, data),
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

  // Menu buttons
  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return SizedBox(
          height: 62,
          child: TextButton(
            onPressed: () {
              var _menuInfo = Provider.of<MenuInfo>(context, listen: false);
              _menuInfo.updateMenu(currentMenuInfo);
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
