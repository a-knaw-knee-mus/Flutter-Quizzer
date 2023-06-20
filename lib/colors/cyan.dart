import 'package:flutter/material.dart';

const MaterialColor cyan = MaterialColor(_cyanPrimaryValue, <int, Color>{
  50: Color(0xFFE3F7F7),
  100: Color(0xFFB8EAEA),
  200: Color(0xFF89DDDD),
  300: Color(0xFF5ACFCF),
  400: Color(0xFF36C4C4),
  500: Color(_cyanPrimaryValue),
  600: Color(0xFF11B3B3),
  700: Color(0xFF0EABAB),
  800: Color(0xFF0BA3A3),
  900: Color(0xFF069494),
});
const int _cyanPrimaryValue = 0xFF13BABA;

const MaterialColor cyanAccent = MaterialColor(_cyanAccentValue, <int, Color>{
  100: Color(0xFFC0FFFF),
  200: Color(_cyanAccentValue),
  400: Color(0xFF5AFFFF),
  700: Color(0xFF41FFFF),
});
const int _cyanAccentValue = 0xFF8DFFFF;