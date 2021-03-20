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
import '../model/destination_model.dart';

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
    final DestinationData = Provider.of<CurrentFollowing>(context).destination;
    Position myCurrentPosition = null;
    currentCarrierData.update(
      current,
      myMapController,
    );

    addMarker(double lat, double lon, Color iconColor) {
      mymarkers.add(
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: LatLng(lat, lon),
          builder: (ctx) => Icon(Icons.location_pin, color: iconColor),
        ),
      );
    }

    void getLocation() async {
      myCurrentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      myMapController.move(
          LatLng(
              myCurrentPosition.latitude, myCurrentPosition.longitude),
          10.0);


        addMarker(myCurrentPosition.latitude, myCurrentPosition.longitude,
            Colors.orangeAccent);

    }

    setState(() {
      try {
        addMarker(currentCarrierData.destination.lat,
            currentCarrierData.destination.lon, Colors.greenAccent);
      } catch (_) {}
      try {
        addMarker(currentCarrierData.nowFollowing.lat,
            currentCarrierData.nowFollowing.lon, Colors.cyan);
      } catch (_) {}
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          "Following beacon ",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).secondaryHeaderColor),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                try{
                  myMapController.move(
                      LatLng(
                        currentCarrierData.nowFollowing.lat,
                        currentCarrierData.nowFollowing.lon,),
                      10.0);
                }catch(e){}

                },
              child: Icon(
                Icons.attribution_outlined,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                getLocation();

              },
              child: Icon(
                Icons.location_history,
                color: Colors.white,
              ),
            ),
          ),
          FloatingActionButton(
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
                  currentCarrierData.nowFollowing.lon,
                  currentCarrierData.destination.destinationName,
                  currentCarrierData.destination.lat,
                  currentCarrierData.destination.lon,
                );
              } catch (e) {
                myBottomSheet(
                    context, "", 12.972442, 77.580643, "", 0.00, 0.00);
              }
            },
          ),
        ],
      ),
    );
  }
}
