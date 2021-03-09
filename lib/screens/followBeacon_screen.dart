import 'package:flutter/material.dart';
import '../screens/currentfollowingBeacon_screen.dart';
import '../utilities/ListAllCarriers_utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowBeacon extends StatefulWidget {
  static const id = "FollowBeacon";

  @override
  _FollowBeaconState createState() => _FollowBeaconState();
}

class _FollowBeaconState extends State<FollowBeacon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('test'),
        onPressed: ()async{
          // await Firebase.initializeApp();
          // FirebaseFirestore.instance.collection('chats/Aditya178i8/loc').snapshots().listen((event) {print(event.docs[0]['test']);});
        },
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Follow the beacon", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: ListAllCarriers(),
      ),
    );
  }

}
