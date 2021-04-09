import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/followerModel.dart';
import '../model/destination_model.dart';

class CurrentFollowing with ChangeNotifier {
  followerDataModel nowFollowing = followerDataModel();
  DestinationDataModel destination = DestinationDataModel();
  double isLatChannged = 90.0000;
  bool beingCarried = false;
  bool initialbeignCarried=false;

  void update(String current, MapController controller) {
    FirebaseFirestore.instance
        .collection('Carriers/${current}/destination')
        .get()
        .then((event) {
      if (event.docs.isEmpty) {
        destination.destinationName = '';
        destination.lat = 00.0000;
        destination.lon = 00.0000;
      }
      destination.destinationName = event.docs[0]['destinationName'];
      destination.lat = event.docs[0]['destLat'];
      destination.lon = event.docs[0]['destLon'];

      //print("${beingCarried} this one");
      notifyListeners();
    });
    // carrier location data
    FirebaseFirestore.instance
        .collection('Carriers/${current}/loc')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      if (event.docs.isEmpty) {
        nowFollowing.name = '_';
        nowFollowing.lat = 90.0000;
        nowFollowing.lon = 135.0000;
      }
      nowFollowing.name = event.docs[0]['name'];
      nowFollowing.lat = event.docs[0]['lat'];
      nowFollowing.lon = event.docs[0]['lon'];
      beingCarried = event.docs[0]['carrying'];
      //print("${nowFollowing.name} this one");

      try {
        if (isLatChannged != nowFollowing.lat  || initialbeignCarried != beingCarried) {
          print("this many time have been called");
          isLatChannged = nowFollowing.lat;
          if(initialbeignCarried != beingCarried){
            initialbeignCarried=beingCarried;
          }

          controller.move(LatLng(nowFollowing.lat, nowFollowing.lon), 15.0);
          notifyListeners();
        }

        // mymarker.markers.first.point.latitude = nowFollowing.lat;
        // mymarker.markers.first.point.longitude = nowFollowing.lon;

        // print(mymarker.markers[0].point.longitude);
      } catch (e) {}
    });
  }
}
