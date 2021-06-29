import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TimeInfo extends ChangeNotifier {
  String _dayTime = DateFormat('HH:mm:ss').format(DateTime.now());
  String _dateTime = DateFormat('EEE, d MMM').format(DateTime.now());

  String getDayTime() => _dayTime;
  String getDateTime() => _dateTime;

  updateCurrentTime() {
    _dayTime = DateFormat('HH:mm:ss').format(DateTime.now());
    _dateTime = DateFormat('EEE, d MMM').format(DateTime.now());
    notifyListeners();
  }
}
