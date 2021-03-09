import 'package:beacon/provider/carrier_provider.dart';
import 'package:flutter/material.dart';
import '../utilities/alertBox_utility.dart';
import 'package:provider/provider.dart';
import '../provider/carrier_provider.dart';
class ListAllCarriers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   final allCarrierData= Provider.of<Carrier>(context);
   final allCarrierDataList = allCarrierData.allcarriers;
    return ListView.builder(
      itemCount: allCarrierDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            'Beacon Carrier : ${allCarrierDataList[index].name}',
            style: TextStyle(color: Colors.white),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          ),
          onTap: () {
            print("working");
            AlertBox(context,index);

          },
        );
      },
    );
  }
}
