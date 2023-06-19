import 'package:flutter/material.dart';

const MaterialColor magenta = MaterialColor(_magentaPrimaryValue, <int, Color>{
  50: Color(0xFFEEE4E9),
  100: Color(0xFFD5BBC8),
  200: Color(0xFFBA8DA3),
  300: Color(0xFF9E5F7E),
  400: Color(0xFF893D63),
  500: Color(_magentaPrimaryValue),
  600: Color(0xFF6C1840),
  700: Color(0xFF611437),
  800: Color(0xFF57102F),
  900: Color(0xFF440820),
});
const int _magentaPrimaryValue = 0xFF741B47;

const MaterialColor magentaAccent = MaterialColor(_magentaAccentValue, <int, Color>{
  100: Color(0xFFFF7AA7),
  200: Color(_magentaAccentValue),
  400: Color(0xFFFF1464),
  700: Color(0xFFFA0055),
});
const int _magentaAccentValue = 0xFFFF4786;