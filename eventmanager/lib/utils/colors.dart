import 'package:flutter/material.dart';

const followBtnColor = Color.fromARGB(255, 172, 192, 242);
const mobileBkgColor = Color.fromARGB(255, 111, 228, 233);
const webBackgroundColor = Color.fromARGB(255, 185, 191, 200);
const focusedBorderColor = Color.fromARGB(255, 0, 87, 241);
const blueLinkColor = Color.fromARGB(255, 4, 109, 196);
const primaryColorBlack = Color.fromARGB(221, 0, 0, 0);
const secondaryColor = Color.fromARGB(255, 94, 104, 128);
const greyShadeTextColor = Color.fromARGB(200, 158, 158, 158);
const fillColor = Color.fromRGBO(238, 238, 238, 1);

class CustomTheme {
  const CustomTheme();

  static const Color bkgGradientStart = Color.fromARGB(255, 15, 161, 200);
  static const Color bkgGradientEnd = Color.fromARGB(255, 170, 220, 190);
  static const Color btnGradientStart = Color.fromARGB(255, 6, 191, 255);
  static const Color btnGradientEnd = Color.fromARGB(255, 45, 116, 255);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[bkgGradientStart, bkgGradientEnd],
    stops: <double>[0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

const LinearGradient backgroundGradientColor = LinearGradient(
    colors: <Color>[CustomTheme.bkgGradientStart, CustomTheme.bkgGradientEnd],
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 1.0),
    stops: <double>[0.0, 1.0],
    tileMode: TileMode.clamp);

const LinearGradient topbBarGradientColor = LinearGradient(
    colors: <Color>[CustomTheme.bkgGradientStart, CustomTheme.bkgGradientStart],
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 1.0),
    stops: <double>[0.0, 1.0],
    tileMode: TileMode.clamp);
