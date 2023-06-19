import 'package:flutter/material.dart';

const MaterialColor red = MaterialColor(_redPrimaryValue, <int, Color>{
  50: Color(0xFFF3E0E0),
  100: Color(0xFFE0B3B3),
  200: Color(0xFFCC8080),
  300: Color(0xFFB84D4D),
  400: Color(0xFFA82626),
  500: Color(_redPrimaryValue),
  600: Color(0xFF910000),
  700: Color(0xFF860000),
  800: Color(0xFF7C0000),
  900: Color(0xFF6B0000),
});
const int _redPrimaryValue = 0xFF990000;

const MaterialColor redAccent = MaterialColor(_redAccentValue, <int, Color>{
  100: Color(0xFFFF9A9A),
  200: Color(_redAccentValue),
  400: Color(0xFFFF3434),
  700: Color(0xFFFF1A1A),
});
const int _redAccentValue = 0xFFFF6767;