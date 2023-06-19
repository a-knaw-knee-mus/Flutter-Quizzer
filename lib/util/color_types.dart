import 'package:flutter/material.dart';
import 'package:flutter_quizzer/colors/blue.dart';
import 'package:flutter_quizzer/colors/cyan.dart';
import 'package:flutter_quizzer/colors/green.dart';
import 'package:flutter_quizzer/colors/magenta.dart';
import 'package:flutter_quizzer/colors/orange.dart';
import 'package:flutter_quizzer/colors/purple.dart';
import 'package:flutter_quizzer/colors/red.dart';
import 'package:flutter_quizzer/colors/yellow.dart';

enum ColorType {
  blue,
  cyan,
  green,
  magenta,
  orange,
  purple,
  red,
  yellow,
}

extension ColorTypeExtension on ColorType {
  MaterialColor getColorSwatch() {
    switch (this) {
      case ColorType.blue:
        return blue;
      case ColorType.cyan:
        return cyan;
      case ColorType.green:
        return green;
      case ColorType.magenta:
        return magenta;
      case ColorType.orange:
        return orange;
      case ColorType.purple:
        return purple;
      case ColorType.red:
        return red;
      case ColorType.yellow:
        return yellow;
      default:
        return purple;
    }
  }
}
