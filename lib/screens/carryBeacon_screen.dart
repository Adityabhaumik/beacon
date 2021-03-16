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
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "CarryBeacon",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextFormField(
                    readOnly: isCarrying,
                    controller: CarryNameController,
                    cursorColor: Theme.of(context).secondaryHeaderColor,
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
                      labelText: "Enter Name",
                      labelStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                             BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Enter Name',
                      hintStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                      child: Text(
                        "Hours :       ${dropdownValue}",
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
                    CarryNameController.text,
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
        ),
      ),
    );
  }
}
