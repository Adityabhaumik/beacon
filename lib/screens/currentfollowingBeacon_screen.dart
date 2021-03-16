import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../utilities/bottomSheet_utility.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import '../provider/currentfollowingBeacon_provider.dart';

class CurrentfollowingBeacon extends StatefulWidget {
  static const id = "CurrentfollowingBeacon";

  @override
  _CurrentfollowingBeaconState createState() => _CurrentfollowingBeaconState();
}

class _CurrentfollowingBeaconState extends State<CurrentfollowingBeacon> {
  @override
  Widget build(BuildContext context) {

    MapController myMapController = MapController();
    List<Marker> mymarkers = [
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(90.0000, 135.0000),
        builder: (ctx) => Icon(Icons.location_pin, color: Colors.orangeAccent),
      ),
    ];
    final current = ModalRoute.of(context).settings.arguments as String;
    final currentCarrierData = Provider.of<CurrentFollowing>(context);
    Position myCurrentPosition = null;
    currentCarrierData.update(
      current,
      myMapController,
    );

    addMarker(double lat, double lon,Color iconColor) {
      mymarkers.add(
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: LatLng(lat, lon),
          builder: (ctx) =>
              Icon(Icons.location_pin, color: iconColor),
        ),
      );
    }
    void getLocation() async {
      myCurrentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        ///Todo make my position visible and destination
        addMarker(myCurrentPosition.latitude,myCurrentPosition.longitude,Colors.orangeAccent);
      });
    }
    setState(() {
      try {

        addMarker(currentCarrierData.nowFollowing.lat,
            currentCarrierData.nowFollowing.lon,Colors.cyan);
      } catch (_) {}
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Following beacon ",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.my_location_outlined), onPressed: () {getLocation();})
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: FlutterMap(
                  mapController: myMapController,
                  options: MapOptions(
                    zoom: 15,
                    center: LatLng(90.0000, 135.0000),
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    MarkerLayerOptions(markers: mymarkers)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(
          Icons.keyboard_arrow_up,
          color: Colors.white,
          size: 35,
        ),
        onPressed: () {
          try {
            myBottomSheet(
                context,
                currentCarrierData.nowFollowing.name,
                currentCarrierData.nowFollowing.lat,
                currentCarrierData.nowFollowing.lon);
          } catch (e) {
            myBottomSheet(context, "", 12.972442, 77.580643);
          }
        },
      ),
    );
  }
}
