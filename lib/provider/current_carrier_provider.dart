import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';
import '../model/currentCarrier_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/destination_model.dart';

class CurrentCarrier with ChangeNotifier {
  CurrentCarrierDataModel _current = CurrentCarrierDataModel();
  DestinationDataModel _currentDestination = DestinationDataModel();
  bool isCarrying = false;
  Timer t;
  Position myCurrentPosition;

  CurrentCarrierDataModel get current_carriers {
    return _current;
  }

  DestinationDataModel get destinationData {
    return _currentDestination;
  }

  bool get isCarryingNow {
    return isCarrying;
  }

  void updateDestination(String newDestinationName, double lat, double lon) {
    _currentDestination.destinationName = newDestinationName;
    _currentDestination.lat = lat;
    _currentDestination.lon = lon;
    notifyListeners();
  }

  void sendEndDoc() {
    FirebaseFirestore.instance
        .collection('Carriers')
        .doc('${_current.id}')
        .collection('loc')
        .add({
      'name': _current.name,
      'lat': myCurrentPosition.latitude,
      'lon': myCurrentPosition.longitude,
      'carrying': false,
      'createdAt': DateTime.now()
    });
  }

  void ClearCarrier()  {
    print('clearData called');
    sendEndDoc();
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

  void startTimer(
    int hour,
    MapController c,
  ) {
    int _counter = 3600 * hour;

    FirebaseFirestore.instance
        .collection('Carriers')
        .doc('${_current.id}')
        .collection('destination')
        .add({
      'destinationName': _currentDestination.destinationName,
      'destLat': _currentDestination.lat,
      'destLon': _currentDestination.lon,
    });
    t = Timer.periodic(Duration(seconds: 30), (_) async {
      if (_counter > 0) {
        _counter = _counter - 30;
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
          'carrying': true,
          'createdAt': DateTime.now()
        });
        notifyListeners();
        // print("${myCurrentPosition.latitude}I working");
      } else {
        ClearCarrier();
        // print("Time Ses");
        // t.cancel();
        // isCarrying = false;

        notifyListeners();
      }
    });

    notifyListeners();
  }
}
