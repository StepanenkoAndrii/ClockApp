import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start_app/enums.dart';
import 'package:start_app/menu_info.dart';
import 'package:start_app/time_info.dart';
import 'homepage.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: (String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  // });
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
