import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/preference.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    ColorType themeColor = context.watch<ColorProvider>().color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            hint: Text(themeColor.getName()),
            iconStyleData: const IconStyleData(
              icon: Icon(Icons.list),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              maxHeight: 207,
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
            onChanged: (ColorType? newColor) {
              context.read<ColorProvider>().color = newColor!;
              Hive.box<Preference>('prefBox').put(
                  'colorTheme',
                  Preference(
                    value: newColor.getName(),
                  ));
            },
            items: ColorType.values.map((ColorType c) {
              return DropdownMenuItem(
                value: c,
                child: Text(
                  c.getName(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
