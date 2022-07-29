import 'package:flutter/material.dart';
import 'package:tm_ressource_tracker/assets.dart';

ThemeData appTheme = ThemeData(
  fontFamily: Fonts.enterSansman,
  primaryColor: Color.fromARGB(255, 140, 80, 38),
  scaffoldBackgroundColor: Colors.transparent,
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(
      fontSize: 16,
      fontFamily: Fonts.enterSansman,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Color.fromRGBO(255, 210, 114, 1),
      ),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return Color.fromARGB(255, 140, 80, 38);
        }
        return Colors.grey;
      },
    ),
    trackColor: MaterialStateProperty.resolveWith(
      (states) {
        if (!states.contains(MaterialState.selected)) {
          return null;
        }
        return Color.fromRGBO(140, 80, 38, 0.8);
      },
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 20),
    bodyMedium: TextStyle(fontSize: 18),
    bodySmall: TextStyle(fontSize: 14),
    displayMedium: TextStyle(fontSize: 27),
    titleMedium: TextStyle(fontSize: 18),
    displaySmall: TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: const Color.fromRGBO(187, 182, 179, 1),
    shape: RoundedRectangleBorder(
      side: BorderSide(
        width: 1,
        color: Colors.black,
      ),
    ),
  ),
);