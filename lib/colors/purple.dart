import 'package:flutter/material.dart';

const MaterialColor purple = MaterialColor(_purplePrimaryValue, <int, Color>{
  50: Color(0xFFE7E4EE),
  100: Color(0xFFC2BBD6),
  200: Color(0xFF9A8EBA),
  300: Color(0xFF72609E),
  400: Color(0xFF533E8A),
  500: Color(_purplePrimaryValue),
  600: Color(0xFF30196D),
  700: Color(0xFF281462),
  800: Color(0xFF221158),
  900: Color(0xFF160945),
});
const int _purplePrimaryValue = 0xFF351C75;

const MaterialColor purpleAccent = MaterialColor(_purpleAccentValue, <int, Color>{
  100: Color(0xFF917CFF),
  200: Color(_purpleAccentValue),
  400: Color(0xFF3B16FF),
  700: Color(0xFF2800FC),
});
const int _purpleAccentValue = 0xFF6649FF;