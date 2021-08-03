import 'package:flutter/material.dart';
import 'package:start_app/other/enums.dart';
import 'package:start_app/other/menu_info.dart';

//Navigation menu icons
List<MenuInfo> menuItems = [
  MenuInfo(
    MenuType.clock,
    title: 'Clock',
    icon: Icon(
      Icons.access_time_rounded,
      color: Colors.white,
      size: 28,
    ),
  ),
  MenuInfo(
    MenuType.alarm,
    title: 'Alarm',
    icon: Icon(
      Icons.access_alarm,
      color: Colors.white,
      size: 28,
    ),
  ),
  MenuInfo(
    MenuType.timer,
    title: 'Timer',
    icon: Icon(
      Icons.hourglass_bottom,
      color: Colors.white,
      size: 28,
    ),
  ),
  MenuInfo(
    MenuType.stopwatch,
    title: 'Stopwatch',
    icon: Icon(
      Icons.timer,
      color: Colors.white,
      size: 28,
    ),
  ),
];
