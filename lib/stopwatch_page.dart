import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:start_app/variables.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final _scrollController = ScrollController();

  // var timeBuffer = 0;

  // void addToTimeBuffer() {
  //   Timer.periodic(
  //     Duration(milliseconds: 1),
  //     (_) {
  //       if (stopwatchIsWorking) timeBuffer += 1;
  //     },
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (stopwatchIsWorking) {
    //   _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    // }
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Stopwatch",
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.center,
              child: StreamBuilder<int>(
                builder: (context, snapshot) {
                  final value = snapshot.data;
                  // final value = timeBuffer;
                  final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: _isHours);
                  return Text(
                    displayTime,
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      fontSize: 54,
                    ),
                  );
                },
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        // stopwatchIsWorking = true;
                        // addToTimeBuffer();
                        // print("time buffer: $timeBuffer");
                      },
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
                      ),
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                        // stopwatchIsWorking = false;
                      },
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
                      ),
                      child: Icon(
                        Icons.pause_circle_outline,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                      },
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text(
                        'Lap',
                        style: GoogleFonts.acme(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                        // stopwatchIsWorking = false;
                        // timeBuffer = 0;
                      },
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.acme(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lap timestamps:',
                    style: GoogleFonts.acme(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: StreamBuilder<List<StopWatchRecord>>(
                      builder: (context, snapshot) {
                        final value = snapshot.data;
                        if (value.isEmpty) {
                          return Container();
                        }
                        Future.delayed(
                          Duration(milliseconds: 100),
                          () {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeOut);
                          },
                        );
                        return ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final data = value[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    '${index + 1} - ${data.displayTime}',
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: value.length,
                        );
                      },
                      stream: _stopWatchTimer.records,
                      initialData: _stopWatchTimer.records.value,
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
