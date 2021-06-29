// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:start_app/enums.dart';
import 'package:start_app/variables.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  Icon icon;

  MenuInfo(this.menuType, {this.title, this.icon});

  updateMenu(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.icon = menuInfo.icon;
    if (this.menuType == MenuType.clock) {
      clockVisible = true;
      alarmVisible = false;
      timerVisible = false;
      stopwatchVisible = false;
    } else if (this.menuType == MenuType.alarm) {
      clockVisible = false;
      alarmVisible = true;
      timerVisible = false;
      stopwatchVisible = false;
    } else if (this.menuType == MenuType.timer) {
      clockVisible = false;
      alarmVisible = false;
      timerVisible = true;
      stopwatchVisible = false;
    } else if (this.menuType == MenuType.stopwatch) {
      clockVisible = false;
      alarmVisible = false;
      timerVisible = false;
      stopwatchVisible = true;
    } else {
      clockVisible = false;
      alarmVisible = false;
      timerVisible = false;
      stopwatchVisible = false;
    }
    notifyListeners();
  }
}
