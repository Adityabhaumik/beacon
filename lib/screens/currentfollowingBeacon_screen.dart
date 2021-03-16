import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    MarkerLayerOptions mymarkers=  MarkerLayerOptions(
      markers: [
        Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 30,
          width: 30,
          point: LatLng(90.0000, 135.0000),
          builder: (ctx) => Icon(Icons.location_pin,
              color: Colors.orangeAccent),
        ),
      ],
    );

    final current = ModalRoute.of(context).settings.arguments as String;
    final currentCarrierData = Provider.of<CurrentFollowing>(context);
    currentCarrierData.update(current, myMapController,mymarkers);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Current following beacon ",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.black,
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
                    mymarkers
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
