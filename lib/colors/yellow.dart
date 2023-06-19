import 'package:flutter/material.dart';

const MaterialColor yellow = MaterialColor(_yellowPrimaryValue, <int, Color>{
  50: Color(0xFFF7F2E0),
  100: Color(0xFFECDEB3),
  200: Color(0xFFDFC880),
  300: Color(0xFFD2B14D),
  400: Color(0xFFC9A126),
  500: Color(_yellowPrimaryValue),
  600: Color(0xFFB98800),
  700: Color(0xFFB17D00),
  800: Color(0xFFA97300),
  900: Color(0xFF9B6100),
});
const int _yellowPrimaryValue = 0xFFBF9000;

const MaterialColor yellowAccent = MaterialColor(_yellowAccentValue, <int, Color>{
  100: Color(0xFFFFE6C6),
  200: Color(_yellowAccentValue),
  400: Color(0xFFFFBA60),
  700: Color(0xFFFFAF47),
});
const int _yellowAccentValue = 0xFFFFD093;