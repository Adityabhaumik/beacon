import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

Future<void> myBottomSheet(
    BuildContext context,
    String currentCarrier,
    double lat,
    double lon,
    String destination,
    double destinationLat,
    double destinationLon,
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
      return Container(
        padding: EdgeInsets.only(left: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

                Text(
                  'Destination :${destination}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

            Text(
              'Destination Lattitude :${destinationLat}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Destination Longitude :${destinationLon}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Beacon Carrier :${currentCarrier}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Beacon Carrier Lattitude :${lat}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Beacon Carrier Longitude :${lon}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    },
  );
}
