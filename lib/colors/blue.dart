import 'package:flutter/material.dart';

const MaterialColor blue = MaterialColor(_bluePrimaryValue, <int, Color>{
  50: Color(0xFFE2EAF2),
  100: Color(0xFFB6CBDF),
  200: Color(0xFF85A9CA),
  300: Color(0xFF5487B4),
  400: Color(0xFF306DA4),
  500: Color(_bluePrimaryValue),
  600: Color(0xFF0A4C8C),
  700: Color(0xFF084281),
  800: Color(0xFF063977),
  900: Color(0xFF032965),
});
const int _bluePrimaryValue = 0xFF0B5394;

const MaterialColor blueAccent = MaterialColor(_blueAccentValue, <int, Color>{
  100: Color(0xFF95B6FF),
  200: Color(_blueAccentValue),
  400: Color(0xFF2F71FF),
  700: Color(0xFF155FFF),
});
const int _blueAccentValue = 0xFF6294FF;