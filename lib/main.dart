import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:start_app/other/enums.dart';
import 'package:start_app/other/menu_info.dart';
import 'package:start_app/other/time_info.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeInfo>(
          create: (context) => TimeInfo(),
        ),
        ChangeNotifierProvider<MenuInfo>(
          create: (context) => MenuInfo(MenuType.clock),
        ),
      ],
      child: MaterialApp(
        home: HomePage(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
