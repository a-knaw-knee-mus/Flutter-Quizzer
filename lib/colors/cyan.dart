import 'package:flutter/material.dart';

const MaterialColor cyan = MaterialColor(_cyanPrimaryValue, <int, Color>{
  50: Color(0xFFE3EAEB),
  100: Color(0xFFB8CACE),
  200: Color(0xFF89A7AE),
  300: Color(0xFF5A848D),
  400: Color(0xFF366974),
  500: Color(_cyanPrimaryValue),
  600: Color(0xFF114854),
  700: Color(0xFF0E3F4A),
  800: Color(0xFF0B3641),
  900: Color(0xFF062630),
});
const int _cyanPrimaryValue = 0xFF134F5C;

const MaterialColor cyanAccent = MaterialColor(_cyanAccentValue, <int, Color>{
  100: Color(0xFF6AD5FF),
  200: Color(_cyanAccentValue),
  400: Color(0xFF04B8FF),
  700: Color(0xFF00A7E9),
});
const int _cyanAccentValue = 0xFF37C6FF;