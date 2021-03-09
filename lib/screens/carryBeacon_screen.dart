import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../utilities/bottomSheetCarryBeacon_utility.dart';
import '../provider/current_carrier_provider.dart';
import 'dart:async';
import 'package:menu_button/menu_button.dart';

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
  TextEditingController CarryNameController = TextEditingController();
  MapController MyMapController = MapController();

  void getLocation() async {
    myCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      positionLoaded = true;
    });
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

    Future<bool> alertBoxOnWillPopCarrier() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content:
                  new Text('By Going Back You Will STOP Carrying The Beacon'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () {

                    CurrentCarrierData.ClearCarrier();
                    return Navigator.of(context).pop(true);
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
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            elevation: 0,
            title: Text(
              "CarryBeacon",
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    controller: CarryNameController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.black26,
                      filled: true,
                      labelText: "Enter Name",
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusColor: Colors.white,
                      hintText: 'Enter Name',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                      child: Text(
                        "Hours :       ${dropdownValue}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    MenuButton<int>(
                      child: Icon(Icons.arrow_drop_down),
                      items:[1,2,3,4],
                      itemBuilder: (int value) => Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Text("${value}"),
                      ),
                      toggledChild: Container(
                        child: Icon(Icons.arrow_drop_down),
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
                            minZoom: 10.0,
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  point: LatLng(myCurrentPosition.latitude,
                                      myCurrentPosition.longitude),
                                  builder: (context) {
                                    return Icon(
                                      Icons.location_pin,
                                      color: Colors.orange,
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ))
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (CarryNameController.text == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Enter Name To Start Carrying the Beacon'),
                  ),
                );
              } else {

                myBottomSheetCarrierScreen(context, CarryNameController.text,
                    myCurrentPosition.latitude, myCurrentPosition.longitude,MyMapController,dropdownValue);

              }
            },
            child: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
