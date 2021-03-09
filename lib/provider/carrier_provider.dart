import 'package:flutter/cupertino.dart';
import '../model/carrier_model.dart';
import 'package:provider/provider.dart';

class Carrier with ChangeNotifier{
  List<CarrierDataModel> _allcarriers=[
    CarrierDataModel(
      lat:19.076090,
      lon:72.877426 ,
      name: 'Aditya'
    ),
    CarrierDataModel(
        lat:24.879999,
        lon:74.629997 ,
        name: 'Pratap'
    ),
    CarrierDataModel(
        lat:21.250000,
        lon:81.629997 ,
        name: 'Harsh'
    ),
    CarrierDataModel(
        lat:26.540457,
        lon:88.719391,
        name: 'Rinon'
    ),
  ];

  List<CarrierDataModel> get allcarriers{
    return [..._allcarriers];
  }

  void addCarrier(){
    //_allcarriers.add(value);
    notifyListeners();
  }

}