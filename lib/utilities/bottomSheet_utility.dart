import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';

import '../provider/currentfollowingBeacon_provider.dart';




Future<void> myBottomSheet(
    BuildContext context,

) {
  return showModalBottomSheet<void>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      final currentCarrierData = Provider.of<CurrentFollowing>(context);
      // currentCarrierData.nowFollowing.name,
      // currentCarrierData.nowFollowing.lat,
      // currentCarrierData.nowFollowing.lon,
      // currentCarrierData.destination.destinationName,
      // currentCarrierData.destination.lat,
      // currentCarrierData.destination.lon,


      return Container(
        padding: EdgeInsets.only(left: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

                Text(
                  'Destination :${currentCarrierData.destination.destinationName}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

            Text(
              'Destination Lattitude :${currentCarrierData.destination.lat}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Destination Longitude :${currentCarrierData.destination.lon}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Beacon Carrier :${currentCarrierData.nowFollowing.name}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Beacon Carrier Lattitude :${currentCarrierData.nowFollowing.lat}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Beacon Carrier Longitude :${currentCarrierData.nowFollowing.lon}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    },
  );
}
