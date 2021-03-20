import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:geocoder/geocoder.dart';
import '../model/destination_model.dart';
import '../provider/current_carrier_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

Widget buildFloatingSearchBar(BuildContext context, MapController controller) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  final CurrentCarrierData = Provider.of<CurrentCarrier>(context);
  final destinationData = CurrentCarrierData.destinationData;

  getDestination(String name) async {
    await Geocoder.local.findAddressesFromQuery(name).then((value) => {
          CurrentCarrierData.updateDestination(
              name,
              value.first.coordinates.latitude,
              value.first.coordinates.longitude),
          print(value.length),
          // value.forEach((element) {
          //   print(element.coordinates.longitude);
          //   destination.add(Container(child: Text("${element.coordinates.longitude}"),));
          //
          // })
        });
  }

  return FloatingSearchBar(
    automaticallyImplyBackButton: false,
    textInputAction: TextInputAction.done,
    queryStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
    hint: destinationData.destinationName == null
        ? 'Enter Destination'
        : destinationData.destinationName,
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onSubmitted: (value) {
      print(value);
      getDestination(value);

    },

    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.my_location_rounded),
          onPressed: () {
            try {
              controller.move(
                  LatLng(destinationData.lat, destinationData.lon), 10.0);
            } catch (_) {}
          },
        ),
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
        ),
      );
    },
  );
}
