import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import '../model/currentCarrier_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentCarrier with ChangeNotifier {
  CurrentCarrierDataModel _current = CurrentCarrierDataModel();
  bool isCarrying = false;
  Timer t;

  CurrentCarrierDataModel get current_carriers {
    return _current;
  }

  bool get isCarryingNow {
    return isCarrying;
  }

  void ClearCarrier() {
    _current.name = "";
    _current.id = "";
    isCarrying = false;
    print(_current.name);
    print(_current.id);
    t.cancel();
    notifyListeners();
  }

  void updateCarrier(String name) {
    _current.name = name;
    _current.id = "${name}${randomAlphaNumeric(5)}";
    isCarrying = true;
    print(_current.name);
    print(_current.id);

    notifyListeners();
  }

  void startTimer(int hour, MapController c) {
    int _counter = 3600 * hour;
    Position myCurrentPosition;
    t = Timer.periodic(Duration(seconds: 1), (_) async {
      if (_counter > 0) {
        _counter--;
        print(_counter);
        myCurrentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        c.move(LatLng(myCurrentPosition.latitude, myCurrentPosition.longitude),
            15.0);
        FirebaseFirestore.instance
            .collection('Carriers')
            .doc('${_current.id}')
            .collection('loc')
            .add({
          'name': _current.name,
          'lat': myCurrentPosition.latitude,
          'lon': myCurrentPosition.longitude,
          'createdAt':DateTime.now()
        });
        print("${myCurrentPosition.latitude}I working");
      } else {
        print("Time Ses");
        t.cancel();
        isCarrying = false;
        notifyListeners();
      }
    });

    notifyListeners();
  }
}
