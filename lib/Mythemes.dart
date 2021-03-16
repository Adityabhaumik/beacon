import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    secondaryHeaderColor: Colors.white,
    primaryColor: Colors.black,
    primarySwatch: Colors.orange,
    accentColor: Colors.orangeAccent,
    cardColor: Colors.black54,
    textTheme: TextTheme(
        headline2: TextStyle(
            color: Colors.white, fontStyle: FontStyle.normal, fontSize: 25),
        headline3: TextStyle(
            color: Colors.white, fontStyle: FontStyle.normal, fontSize: 18),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        subtitle1: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.white),
        subtitle2: TextStyle(fontSize: 14.0, color: Colors.white)),
    scaffoldBackgroundColor: Colors.black54);

ThemeData liteTheme = ThemeData(
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    // Define the default brightness and colors.
    brightness: Brightness.light,
    secondaryHeaderColor: Colors.black,
    primaryColor: Colors.white,
    primarySwatch: Colors.orange,
    accentColor: Colors.orangeAccent,
    cardColor: Colors.white,
    textTheme: TextTheme(
        headline2: TextStyle(
            color: Colors.black, fontStyle: FontStyle.normal, fontSize: 25),
        headline3: TextStyle(
            color: Colors.black, fontStyle: FontStyle.normal, fontSize: 18),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        subtitle1: TextStyle(color: Colors.white),
        caption: TextStyle(color: Colors.black),
        subtitle2: TextStyle(fontSize: 14.0, color: Colors.black)),
    scaffoldBackgroundColor: Colors.black54);
