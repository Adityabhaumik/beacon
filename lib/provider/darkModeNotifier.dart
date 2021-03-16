import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DarkNotifier with ChangeNotifier{
  bool isDark=false;

  Future<void> _loadWetherDark()async{
   await SharedPreferences.getInstance().then((value) {
      isDark= value.getBool('Dark')??false;
    });
    notifyListeners();
  }
  Future<void> saveWetherDark(bool isDarknow)async{
    await SharedPreferences.getInstance().then((value) {
      value.setBool('Dark', isDarknow);
      isDark=isDarknow;
    });
    notifyListeners();
  }
  DarkNotifier(){
    _loadWetherDark();
  }
}