import 'package:flutter/material.dart';

enum AppTheme {
  Theme1
}


final appThemeData = {
  AppTheme.Theme1: ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF07438c),
    canvasColor: Color(0xFFffffff),
    backgroundColor: Color(0xff4083d5),
    secondaryHeaderColor: Color(0xffff7800),
    accentColor: Colors.grey[800],
    accentTextTheme: TextTheme(
      headline1: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
    ),
    fontFamily: 'CeraPro',
    textTheme: TextTheme(
        headline1: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
        headline3: TextStyle(fontSize: 18, color: Color(0xff222222), fontWeight: FontWeight.bold),
        headline4: TextStyle(fontSize: 12.0, color: Color(0xff222222), fontWeight: FontWeight.normal),
        headline6: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold),
        button: TextStyle(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.normal),
        bodyText1: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal),
        bodyText2: TextStyle(fontSize: 12.0, color: Color(0xFFFFFFFF), fontWeight: FontWeight.normal),),
    buttonColor: Color(0xff4083d5),
    splashColor: Colors.white.withOpacity(0),
    highlightColor: Colors.white.withOpacity(0),
    disabledColor: Color(0xffcce6e2),
    primaryIconTheme: IconThemeData(color: Colors.white, opacity: 1),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      selectedIconTheme: IconThemeData(
        color: Color(0xFF428f83),
        opacity: 1,
        size: 24,
      ),
      unselectedIconTheme: IconThemeData(
        color: Color(0xFFa7a7a7),
        opacity: 1,
        size: 24,
      ),
      selectedItemColor: Color(0xFFf1f3f6),
      unselectedItemColor: Color(0xFFF1f3f6),
      selectedLabelStyle: TextStyle(
        color: Color(0xFF428f83),
        fontFamily: 'CeraPro',
        fontSize: 14,
      ),
      unselectedLabelStyle: TextStyle(
        color: Color(0xFF428f83),
        fontFamily: 'CeraPro',
        fontSize: 14,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
  )
};
