import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:start_app/other/time_info.dart';

import '../other/clock_view.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  @override
  Widget build(BuildContext context) {
    var _now = DateTime.now();
    var _timezoneString = _now.timeZoneOffset.toString().split(".").first;
    var _offsetSign = '';
    if (!_timezoneString.startsWith('-')) _offsetSign = '+';

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
                  "Clock",
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<TimeInfo>(
                  builder: (context, data, child) {
                    return Text(
                      data.getDayTime(),
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(color: Colors.white, fontSize: 64),
                      ),
                    );
                  },
                ),
                Consumer<TimeInfo>(
                  builder: (context, data, child) {
                    return Text(
                      data.getDateTime(),
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.center,
              child: ClockView(
                size: 300,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Timezone",
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "UTC" + _offsetSign + _timezoneString,
                      style: GoogleFonts.acme(
                        textStyle: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
