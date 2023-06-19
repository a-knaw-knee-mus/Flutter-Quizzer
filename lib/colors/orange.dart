import 'package:flutter/material.dart';

const MaterialColor orange = MaterialColor(_orangePrimaryValue, <int, Color>{
  50: Color(0xFFF6ECE1),
  100: Color(0xFFE9CFB4),
  200: Color(0xFFDAAF83),
  300: Color(0xFFCB8F51),
  400: Color(0xFFBF772B),
  500: Color(_orangePrimaryValue),
  600: Color(0xFFAD5705),
  700: Color(0xFFA44D04),
  800: Color(0xFF9C4303),
  900: Color(0xFF8C3202),
});
const int _orangePrimaryValue = 0xFFB45F06;

const MaterialColor orangeAccent = MaterialColor(_orangeAccentValue, <int, Color>{
  100: Color(0xFFFFCCB8),
  200: Color(_orangeAccentValue),
  400: Color(0xFFFF8252),
  700: Color(0xFFFF7039),
});
const int _orangeAccentValue = 0xFFFFA785;