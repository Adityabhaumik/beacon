import 'package:beacon/provider/darkModeNotifier.dart';
import 'package:provider/provider.dart';
import '../utilities/alertBox_utility.dart';
import './carryBeacon_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FirstScreen extends StatefulWidget {
  static const id = "FirstScreen";

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    initializeFirebase();

    super.initState();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final isNowDark = Provider.of<DarkNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
        IconButton(icon:isNowDark.isDark?Icon(Icons.wb_sunny):Icon(Icons.nights_stay), onPressed: (){
          isNowDark.saveWetherDark(!isNowDark.isDark);
        })
      ],),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        margin: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Gretel',
                style: Theme.of(context).textTheme.headline2,
              ),
              Expanded(
                flex: 3,
                child: Image(
                  image: isNowDark.isDark?AssetImage('assets/backimg1.png'):AssetImage('assets/backimg_white.png'),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CarryBeacon.id);
                  },
                  child: Text(
                    "Carry The Beacon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AlertBox(context, 1);
                    // Navigator.pushNamed(context, FollowBeacon.id);
                  },
                  child: Text(
                    "Follow The Beacon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
