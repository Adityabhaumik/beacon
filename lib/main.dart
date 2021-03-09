import 'package:beacon/screens/currentfollowingBeacon_screen.dart';
import 'package:flutter/material.dart';
import './screens/first_screen.dart';
import './screens/followBeacon_screen.dart';
import './screens/carryBeacon_screen.dart';
import './provider/current_carrier_provider.dart';
import 'package:provider/provider.dart';
import './provider/carrier_provider.dart';
import './provider/currentfollowingBeacon_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Carrier()),
        ChangeNotifierProvider(create: (context) => CurrentCarrier()),
        ChangeNotifierProvider(create: (context) => CurrentFollowing()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.orange,
        ),
        home: FirstScreen(),
        routes: {
          FirstScreen.id: (context) => FirstScreen(),
          CarryBeacon.id: (context) => CarryBeacon(),
          FollowBeacon.id: (context) => FollowBeacon(),
          CurrentfollowingBeacon.id: (context) => CurrentfollowingBeacon(),
        },
      ),
    );
  }
}
