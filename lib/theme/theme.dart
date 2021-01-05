import 'package:flutter/material.dart';

enum AppTheme { Theme1 }

final appThemeData = {
  AppTheme.Theme1: ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF393D53), //header bars for apps / popups
      canvasColor: Color(0xFFE3E5E9), // mia fora sto main
      backgroundColor: Color(0xffffffff), // gia tous containers, full app & popup
      secondaryHeaderColor: Color(0xff9FBFFF), //stis endiameses lwrides sta browser games
      accentColor: Color(0xFFFFB300),
      shadowColor: Color(0xff000000),
      accentTextTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: 'CeraPro',
        ),
      ),
      fontFamily: 'CeraPro',
      textTheme: TextTheme(
        // gia app/popup titles
        headline1: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'CeraPro',
        ),
        //paizei sto home/suggested games/ subheaders
        headline2: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'CeraPro',
        ),
        headline3: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontFamily: 'CeraPro',
        ),

        //gia to panel button, active
        headline4: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF393D53),
          fontWeight: FontWeight.normal,
          fontFamily: 'CeraPro',
        ),
        //gia to panel button , inactive
        headline5: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9597A3),
          fontWeight: FontWeight.normal,
          fontFamily: 'CeraPro',
        ),

        //paizei sto home/suggested games/ subheaders
        headline6: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'CeraPro',
        ),
        button: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'CeraPro',
        ),
        bodyText1: TextStyle(fontSize: 12.0, color: Color(0xFF111111), fontWeight: FontWeight.normal),
        bodyText2: TextStyle(
          fontSize: 12.0,
          color: Color(0xfF111111),
          fontWeight: FontWeight.bold,
          fontFamily: 'CeraPro',
        ),
      ),
      buttonColor: Color(0xff63ABFF),
      splashColor: Colors.white.withOpacity(0),
      highlightColor: Colors.grey,
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
      ))
};
