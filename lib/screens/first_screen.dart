import 'package:beacon/provider/darkModeNotifier.dart';
import 'package:provider/provider.dart';
import '../utilities/alertBox_utility.dart';
import './carryBeacon_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../provider/name_provider.dart';
import '../utilities/askname_utility.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import '../screens/currentfollowingBeacon_screen.dart';
class FirstScreen extends StatefulWidget {
  static const id = "FirstScreen";

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    initializeFirebase();
    initDynamicLinks();
    super.initState();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp();
  }


  void initDynamicLinks() async {
    print("initDynamicLinks");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            // Navigator.pushNamed(context, CurrentfollowingBeacon.id,
            //      arguments: deepLink.queryParameters['id']);
            print("${deepLink.queryParameters['id']}");
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print("${deepLink.queryParameters["id"]}");
      Navigator.pushNamed(context, CurrentfollowingBeacon.id,
          arguments: deepLink.queryParameters["id"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNowDark = Provider.of<DarkNotifier>(context);
    String UserName = Provider.of<NameNotifier>(context,listen: true).name;
    bool isNameSaved =Provider.of<NameNotifier>(context,listen: true).isNameSaved;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Gretel',
          style: Theme.of(context).textTheme.headline2,
        ),
        elevation: 0.0,
        actions: [
          IconButton(
              icon: isNowDark.isDark
                  ? Icon(Icons.wb_sunny)
                  : Icon(Icons.nights_stay),
              onPressed: () {
                isNowDark.saveWetherDark(!isNowDark.isDark);
              })
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        margin: EdgeInsets.all(20),
        child: isNameSaved
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sup ! ${UserName}',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Expanded(
                      flex: 3,
                      child: Image(
                        image: isNowDark.isDark
                            ? AssetImage('assets/backimg1.png')
                            : AssetImage('assets/backimg_white.png'),
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
              )
            : AlertBoxAskName(context),
      ),
    );
  }
}
