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
  var _dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    var _centerX = size.width / 2;
    var _centerY = size.height / 2;
    var _center = Offset(_centerX, _centerY);
    var _radius = min(_centerX, _centerY);

    var _fillBrush = Paint()..color = Colors.black;
    var _outlineBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 62.5
      ..color = Color(0xFFEAECFF);
    var _centerFillBrush = Paint()..color = Color(0xFFEAECFF);

    // Hands' brushes
    var _secHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 125
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    var _minHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 62.5
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    var _hourHandBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 42
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    var _dashBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Color(0xFFEAECFF);

    canvas.drawCircle(_center, _radius * 0.75, _fillBrush);
    canvas.drawCircle(_center, _radius * 0.75, _outlineBrush);

    // Getting hands' coordinates and draw them
    var _hourHandX = _centerX +
        (_radius * 0.375) *
            cos((_dateTime.hour * 30 + _dateTime.minute * 0.5) * pi / 180);
    var _hourHandY = _centerY +
        (_radius * 0.375) *
            sin((_dateTime.hour * 30 + _dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(_center, Offset(_hourHandX, _hourHandY), _hourHandBrush);

    var _minHandX = _centerX +
        (_radius * 0.5) *
            cos((_dateTime.minute * 6 + _dateTime.second * 0.1) * pi / 180);
    var _minHandY = _centerY +
        (_radius * 0.5) *
            sin((_dateTime.minute * 6 + _dateTime.second * 0.1) * pi / 180);
    canvas.drawLine(_center, Offset(_minHandX, _minHandY), _minHandBrush);

    var _secHandX =
        _centerX + (_radius * 0.6) * cos(_dateTime.second * 6 * pi / 180);
    var _secHandY =
        _centerY + (_radius * 0.6) * sin(_dateTime.second * 6 * pi / 180);
    canvas.drawLine(_center, Offset(_secHandX, _secHandY), _secHandBrush);

    // Drawing clock's edges
    var _smallOuterCircleRadius = _radius - _radius / 12.5;
    var _smallInnerCircleRadius = _radius - _radius / 7.8125;
    var _outerCircleRadius = _radius;
    var _innerCircleRadius = _radius - _radius / 7.8125;
    for (var i = 0; i < 360; i += 6) {
      if (i % 30 == 0) {
        var x1 = _centerX + _outerCircleRadius * cos(i * pi / 180);
        var y1 = _centerY + _outerCircleRadius * sin(i * pi / 180);
        var x2 = _centerX + _innerCircleRadius * cos(i * pi / 180);
        var y2 = _centerY + _innerCircleRadius * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _dashBrush);
      } else {
        var x1 = _centerX + _smallOuterCircleRadius * cos(i * pi / 180);
        var y1 = _centerY + _smallOuterCircleRadius * sin(i * pi / 180);
        var x2 = _centerX + _smallInnerCircleRadius * cos(i * pi / 180);
        var y2 = _centerY + _smallInnerCircleRadius * sin(i * pi / 180);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _dashBrush);
      }
    }

    canvas.drawCircle(_center, size.width / 42, _centerFillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
