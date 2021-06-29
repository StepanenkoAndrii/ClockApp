import 'dart:async';

// import 'package:flutter/material.dart';

var timeBuffer = 0;
bool stopwatchIsWorking = false;
bool anotherPage = false;

void addToTimeBuffer() {
  if (stopwatchIsWorking && anotherPage) {
    Timer.periodic(
      Duration(milliseconds: 10),
      (_) {
        timeBuffer += 10;
      },
    );
  }
}

var clockVisible = true;
var alarmVisible = false;
var timerVisible = false;
var stopwatchVisible = false;

// bool timeIsPicked = false;
// bool dateIsPicked = false;
// TimeOfDay pickedTime;
// DateTime pickedDate;
int id = 0;
