import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../provider/current_carrier_provider.dart';
import '../utilities/alertBoxCarrier.dart';

Future<void> myBottomSheetCarrierScreen(
    BuildContext context, String currentCarrier, double lat, double lon,MapController controller,int time) {
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
      return Container(
        padding: EdgeInsets.only(left: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Your id :${CurrentCarrierNameId.id}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your Name :${currentCarrier}',
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
            CurrentCarrierData.isCarryingNow? ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0.0)),
                onPressed: () {
                  CurrentCarrierData.ClearCarrier();
                  alertBoxCarrier(context,"You Have Stoped Carrying the Beacon","");
                },
                child:Text(
                  "Stop Carrying The Beacon",
                )):ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0.0)),
                onPressed: () {
                  CurrentCarrierData.updateCarrier(currentCarrier);
                  print("yaha tak hua");
                  CurrentCarrierData.startTimer(time,controller);
                  alertBoxCarrier(context,"You Have Started Carrying the Beacon","Ask your Friends To Enter Your Id to Follow");
                },
                child:Text(
                  "Start Carrying The Beacon",
                ))
          ],
        ),
      );
    },
  );
}