import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/followerModel.dart';

class CurrentFollowing with ChangeNotifier {
  followerDataModel nowFollowing = followerDataModel();

  void update(
      String current, MapController controller, MarkerLayerOptions mymarker) {
    FirebaseFirestore.instance
        .collection('Carriers/${current}/loc')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) {
        nowFollowing.name ='Error May be Wrong Code';
        nowFollowing.lat = 90.0000;
        nowFollowing.lon =135.0000;
      }
      nowFollowing.name = event.docs[0]['name'];
      nowFollowing.lat = event.docs[0]['lat'];
      nowFollowing.lon = event.docs[0]['lon'];
      print("${nowFollowing.name} this one");
      try {
        controller.move(LatLng(nowFollowing.lat, nowFollowing.lon), 15.0);
        mymarker.markers[0].point.longitude = nowFollowing.lon;
        mymarker.markers[0].point.latitude = nowFollowing.lat;
        // print(mymarker.markers[0].point.longitude);
      } catch (e) {}
    });
    notifyListeners();
  }
}
