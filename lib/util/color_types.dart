import 'package:flutter/foundation.dart';
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
  String get name => describeEnum(this);

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

  Color getColor() {
    switch (this) {
      case ColorType.blue:
        return Colors.blue;
      case ColorType.cyan:
        return Colors.cyan;
      case ColorType.green:
        return Colors.green;
      case ColorType.magenta:
        return const Color.fromARGB(255, 116, 27, 71);
      case ColorType.orange:
        return Colors.orange;
      case ColorType.purple:
        return Colors.purple;
      case ColorType.red:
        return Colors.red;
      case ColorType.yellow:
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }

  String getName() {
    switch (this) {
      case ColorType.blue:
        return 'Blue';
      case ColorType.cyan:
        return 'Cyan';
      case ColorType.green:
        return 'Green';
      case ColorType.magenta:
        return 'Magenta';
      case ColorType.orange:
        return 'Orange';
      case ColorType.purple:
        return 'Purple';
      case ColorType.red:
        return 'Red';
      case ColorType.yellow:
        return 'Yellow';
      default:
        return 'Purple';
    }
  }

  static ColorType getColorTypeFromString(String color) {
    color = color.toLowerCase();

    switch (color) {
      case 'blue':
        return ColorType.blue;
      case 'cyan':
        return ColorType.cyan;
      case 'green':
        return ColorType.green;
      case 'magenta':
        return ColorType.magenta;
      case 'orange':
        return ColorType.orange;
      case 'purple':
        return ColorType.purple;
      case 'red':
        return ColorType.red;
      case 'yellow':
        return ColorType.yellow;
      default:
        return ColorType.purple;
    }
  }
}
