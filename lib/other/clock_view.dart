import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  final double size;

  const ClockView({Key key, this.size}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (this.mounted) {
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = Colors.black;
    var outlineBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 62.5
      ..color = Color(0xFFEAECFF);
    var centerFillBrush = Paint()..color = Color(0xFFEAECFF);

    var secHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 125
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    var minHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 62.5
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    var hourHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 42
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    var dashBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Color(0xFFEAECFF);

    canvas.drawCircle(center, radius * 0.75, fillBrush);
    canvas.drawCircle(center, radius * 0.75, outlineBrush);

    var hourHandX = centerX +
        (radius * 0.375) *
            cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        (radius * 0.375) *
            sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX +
        (radius * 0.5) *
            cos((dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180);
    var minHandY = centerY +
        (radius * 0.5) *
            sin((dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX =
        centerX + (radius * 0.6) * cos(dateTime.second * 6 * pi / 180);
    var secHandY =
        centerY + (radius * 0.6) * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    var smallOuterCircleRadius = radius - radius / 12.5;
    var smallInnerCircleRadius = radius - radius / 7.8125;
    var outerCircleRadius = radius;
    var innerCircleRadius = radius - radius / 7.8125;
    for (var i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
        var y1 = centerY + outerCircleRadius * sin(i * pi / 180);
        var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
        var y2 = centerY + innerCircleRadius * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
      } else {
        var x1 = centerX + smallOuterCircleRadius * cos(i * pi / 180);
        var y1 = centerY + smallOuterCircleRadius * sin(i * pi / 180);
        var x2 = centerX + smallInnerCircleRadius * cos(i * pi / 180);
        var y2 = centerY + smallInnerCircleRadius * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
      }
    }

    canvas.drawCircle(center, size.width / 42, centerFillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
