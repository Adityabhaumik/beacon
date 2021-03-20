import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../utilities/bottomSheetCarryBeacon_utility.dart';
import '../provider/current_carrier_provider.dart';
import 'dart:async';
import 'package:menu_button/menu_button.dart';
import '../utilities/enterDestinationbar_utility.dart';

class CarryBeacon extends StatefulWidget {
  static const id = "CarryBeacon";

  @override
  _CarryBeaconState createState() => _CarryBeaconState();
}

class _CarryBeaconState extends State<CarryBeacon> {
  bool isCarrying = false;
  int dropdownValue = 1;
  bool positionLoaded = false;
  Position myCurrentPosition = null;
  Position DestinationPosition = null;
  TextEditingController controller = TextEditingController();
  MapController MyMapController = MapController();

  void getLocation() async {
    myCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    updateMarkers(myCurrentPosition.latitude, myCurrentPosition.longitude,
        Colors.orangeAccent);
    setState(() {
      positionLoaded = true;
    });
  }

  List<Marker> mymarkers = [];

  updateMarkers(double lat, double lon, Color color) {
    mymarkers.add(
      Marker(
        point: LatLng(lat, lon),
        builder: (context) {
          return Icon(
            Icons.location_pin,
            color: color,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final CurrentCarrierData = Provider.of<CurrentCarrier>(context);
    final CurrentCarrierNameId = CurrentCarrierData.current_carriers;
    final Destinationdata = CurrentCarrierData.destinationData;

    setState(() {
      try{
        updateMarkers(Destinationdata.lat, Destinationdata.lon, Colors.greenAccent);
      }catch(e){}

    });

    Future<bool> alertBoxOnWillPopCarrier() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text(
                'Are you sure?',
                style: Theme.of(context).textTheme.headline2,
              ),
              content: new Text(
                'By Going Back You Will STOP Carrying The Beacon',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () {
                    try {
                      CurrentCarrierData.ClearCarrier();
                    } catch (_) {}

                    Navigator.of(context).pop(true);
                  },
                  child: Text("YES"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: alertBoxOnWillPopCarrier,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).primaryColor,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                          child: Text(
                            "Hours :       ${dropdownValue}",
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        ),
                        Container(
                          width: (MediaQuery.of(context).size.width) * 0.3,
                          child: MenuButton<int>(
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            items: [1, 2, 3, 4],
                            itemBuilder: (int value) => Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 4),
                              child: Text(
                                "${value}  hour",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            toggledChild: Container(
                              child: Icon(Icons.arrow_drop_up,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            onItemSelected: (int value) {
                              setState(() {
                                dropdownValue = value;
                                print(dropdownValue);
                              });
                            },
                            onMenuButtonToggle: (bool isToggle) {
                              print(isToggle);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  positionLoaded == false
                      ? Expanded(
                          flex: 9,
                          child: Center(child: CircularProgressIndicator()))
                      : Expanded(
                          flex: 9,
                          child: Container(
                            color: Colors.red,
                            child: FlutterMap(
                              mapController: MyMapController,
                              options: MapOptions(
                                center: LatLng(myCurrentPosition.latitude,
                                    myCurrentPosition.longitude),
                                minZoom: 15.0,
                              ),
                              layers: [
                                TileLayerOptions(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c'],
                                ),
                                MarkerLayerOptions(markers: mymarkers)
                              ],
                            ),
                          ))
                ],
              ),
              buildFloatingSearchBar(context,MyMapController)
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(onPressed: (){
                  MyMapController.move(LatLng(myCurrentPosition.latitude,
                    myCurrentPosition.longitude), 10.0);
                },child: Icon(Icons.location_history, color: Colors.white,),),
              ),
              FloatingActionButton(
                onPressed: () {
                  if (1==2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
                          'Enter Name To Start Carrying the Beacon',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    );
                  } else {
                    myBottomSheetCarrierScreen(
                        context,
                        controller.text,
                        myCurrentPosition.latitude,
                        myCurrentPosition.longitude,
                        MyMapController,
                        dropdownValue);
                  }
                },
                child: Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
