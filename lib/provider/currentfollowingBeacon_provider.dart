import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import '../model/currentCarrier_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/followerModel.dart';

class CurrentFollowing with ChangeNotifier {
  followerDataModel nowFollowing = followerDataModel();

  void update(String current, MapController controller) {
    FirebaseFirestore.instance
        .collection('Carriers/${current}/loc').orderBy('createdAt',descending: true)
        .snapshots()
        .listen((event) {
      nowFollowing.name = event.docs[0]['name'];
      nowFollowing.lat = event.docs[0]['lat'];
      nowFollowing.lon = event.docs[0]['lon'];
      print("${nowFollowing.name} this one");
      try{
        controller.move(LatLng(nowFollowing.lat, nowFollowing.lon), 10.0);
        print("controller empty ");
      } catch(e) {
        // controller.move(LatLng(19.076090
        //     , 72.877426), 10.0);
      }
    });
    notifyListeners();
  }
}
