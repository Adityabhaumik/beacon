import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NameNotifier with ChangeNotifier{
  String name="";
  bool isNameSaved=false;

  Future<void> _loadName()async{
    await SharedPreferences.getInstance().then((value) {
      isNameSaved= value.getBool('isNameSaved')??false;
    });
    await SharedPreferences.getInstance().then((value) {
      name = value.getString('name')??"XYZ";
    });
    notifyListeners();
  }
  Future<void> saveName(String userName)async{
    await SharedPreferences.getInstance().then((value) {
      value.setString('name', userName);
      name=userName;
    });
    await SharedPreferences.getInstance().then((value) {
      value.setBool('isNameSaved', true);
      isNameSaved=true;
    });
    notifyListeners();
  }
  NameNotifier(){
    _loadName();
  }
}