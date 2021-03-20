import 'package:beacon/screens/currentfollowingBeacon_screen.dart';
import 'package:flutter/material.dart';
import './screens/first_screen.dart';
import './screens/carryBeacon_screen.dart';
import './provider/current_carrier_provider.dart';
import 'package:provider/provider.dart';
import './provider/currentfollowingBeacon_provider.dart';
import './provider/darkModeNotifier.dart';
import 'Mythemes.dart';
import './provider/name_provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentCarrier()),
        ChangeNotifierProvider(create: (context) => CurrentFollowing()),
        ChangeNotifierProvider(create: (context) => DarkNotifier()),
        ChangeNotifierProvider(create: (context) => NameNotifier()),

      ],
      child: MyApp()),);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Provider
          .of<DarkNotifier>(context)
          .isDark ? darkTheme : liteTheme,
      home: FirstScreen(),
      routes: {
        FirstScreen.id: (context) => FirstScreen(),
        CarryBeacon.id: (context) => CarryBeacon(),
        CurrentfollowingBeacon.id: (context) => CurrentfollowingBeacon(),
      },
    );
  }
}
