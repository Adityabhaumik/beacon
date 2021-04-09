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
  MapController myMapController = MapController();
  Position myCurrentPosition;
  List<Marker> mymarkers = [
    Marker(
      anchorPos: AnchorPos.align(AnchorAlign.center),
      height: 30,
      width: 30,
      point: LatLng(90.0000, 135.0000),
      builder: (ctx) => Icon(Icons.location_pin, color: Colors.orangeAccent),
    ),
  ];

  addMarker(double lat, double lon, Color iconColor,IconData pirticularIcon) {
    mymarkers.add(
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(lat, lon),
        builder: (ctx) => Icon(pirticularIcon, color: iconColor),
      ),
    );
  }

  Future<void> getlocation() async{
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high).then((value) {
      myCurrentPosition=value;
      addMarker(myCurrentPosition.latitude,
          myCurrentPosition.longitude, Colors.red,Icons.location_pin);
    });

  }

  @override
  Widget build(BuildContext context) {

    final current = ModalRoute.of(context).settings.arguments as String;
    final currentCarrierData = Provider.of<CurrentFollowing>(context);


    currentCarrierData.update(
      current,
      myMapController,
    );

    setState(() {
      try {
        addMarker(currentCarrierData.destination.lat,
            currentCarrierData.destination.lon, Colors.red,Icons.flag_outlined);
      } catch (_) {}
      try {
        addMarker(currentCarrierData.nowFollowing.lat,
            currentCarrierData.nowFollowing.lon, Colors.cyan,Icons.location_pin);
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.adjust_rounded,color: currentCarrierData.beingCarried?Colors.green:Colors.redAccent,),
          )
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
                          "https://api.mapbox.com/styles/v1/compileadi/ckmith0h51sji17qv1ejg6jnr/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY29tcGlsZWFkaSIsImEiOiJja2JlbXR5NTUwbjFqMnNxZXRrOXlienRiIn0.QLO2Ma7PvpNPpdSGM6I4lQ",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoiY29tcGlsZWFkaSIsImEiOiJja21pc2htY2Qwa2MxMnBzMTViaDNvODZmIn0.4zbZKwEfVQ9VZ13GTZp3iw',
                        'id': 'mapbox.mapbox-streets-v8'
                      },
                    ),
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
                try {
                  myMapController.onReady.then((result) {
                    myMapController.move(
                        LatLng(currentCarrierData.nowFollowing.lat,
                            currentCarrierData.nowFollowing.lon),
                        15.0);
                  });
                } catch (e) {}
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
              onPressed: () async {
                await getlocation();
                print("${myMapController} this one");
                myMapController.move(
                    LatLng(myCurrentPosition.latitude,
                        myCurrentPosition.longitude),
                    15.0);

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
              myBottomSheet(
                context,
              );
            },
          ),
        ],
      ),
    );
  }
}
