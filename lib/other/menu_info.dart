import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:start_app/other/enums.dart';

class MenuInfo extends ChangeNotifier {
  MenuType menuType;
  String title;
  Icon icon;

  MenuInfo(this.menuType, {this.title, this.icon});

  updateMenu(MenuInfo menuInfo) {
    this.menuType = menuInfo.menuType;
    this.title = menuInfo.title;
    this.icon = menuInfo.icon;
    notifyListeners();
  }
}
