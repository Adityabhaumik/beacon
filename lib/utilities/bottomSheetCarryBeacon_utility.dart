import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../provider/current_carrier_provider.dart';
import '../utilities/alertBoxCarrier.dart';
import '../provider/name_provider.dart';
import 'package:share/share.dart';
import '../utilities/dyLink.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
Future<void> myBottomSheetCarrierScreen(
    BuildContext context,
    String currentCarrier,
    double lat,
    double lon,
    MapController controller,
    int time) {
  return showModalBottomSheet<void>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      final CurrentCarrierData = Provider.of<CurrentCarrier>(context);
      final CurrentCarrierNameId = CurrentCarrierData.current_carriers;
      final CurrentCarrierDestination = CurrentCarrierData.destinationData;
      var urldata;

      String UserName = Provider.of<NameNotifier>(context, listen: true).name;
      return Container(
        padding: EdgeInsets.only(left: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: CurrentCarrierData.isCarryingNow
                  ? [
                      Text(
                        'Your id :${CurrentCarrierNameId.id}',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () {
                                Share.share("${CurrentCarrierNameId.id}");
                                //FlutterClipboard.copy("${CurrentCarrierNameId.id}");
                              }),
                          IconButton(
                              icon: Icon(Icons.link),
                              onPressed: () async{
                                urldata = await createDynamicLink(CurrentCarrierNameId.id,UserName);
                                Share.share(urldata);
                                //Share.share("${CurrentCarrierNameId.id}");
                                //FlutterClipboard.copy("${CurrentCarrierNameId.id}");
                              })
                        ],
                      ),
                    ]
                  : [
                      Text(
                        'Currently Not Carrying',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container()
                    ],
            ),
            Text(
              'Your Name :${UserName}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your Lattitude :${lat}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your Longitude :${lon}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Destination :${CurrentCarrierDestination.destinationName}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Destination Lattitude :${CurrentCarrierDestination.lat}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Destination Longitude :${CurrentCarrierDestination.lon}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            CurrentCarrierData.isCarryingNow
                ? ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                        elevation: MaterialStateProperty.all<double>(0.0)),
                    onPressed: () async{
                      await CurrentCarrierData.ClearCarrier();
                      alertBoxCarrier(
                          context, "You Have Stoped Carrying the Beacon", "");
                    },
                    child: Text(
                      "Stop Carrying The Beacon",
                    ))
                : ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent),
                        elevation: MaterialStateProperty.all<double>(0.0)),
                    onPressed: () async {
                      await  CurrentCarrierData.updateCarrier(UserName);
                      print("yaha tak hua");
                      await CurrentCarrierData.startTimer(time, controller);
                      alertBoxCarrier(
                          context,
                          "You Have Started Carrying the Beacon",
                          "Ask your Friends To Enter Your Id to Follow");
                    },
                    child: Text(
                      "Start Carrying The Beacon",
                    ))
          ],
        ),
      );
    },
  );
}
