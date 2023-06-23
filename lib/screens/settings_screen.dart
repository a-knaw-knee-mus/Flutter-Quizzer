import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/preference.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/widgets/reset_app_dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    ColorType themeColor = context.watch<ColorProvider>().color;
    AlignType alignType = context.watch<AlignProvider>().alignType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tile display type: '),
                SegmentedButton<AlignType>(
                  segments: const <ButtonSegment<AlignType>>[
                    ButtonSegment<AlignType>(
                        value: AlignType.left,
                        label: Text('Left'),
                        icon: Icon(Icons.arrow_back_ios_rounded)),
                    ButtonSegment<AlignType>(
                      value: AlignType.right,
                      label: Text('Right'),
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                  selected: <AlignType>{alignType},
                  onSelectionChanged: (Set<AlignType> newAlignType) {
                    context.read<AlignProvider>().alignType =
                        newAlignType.first;
                    Hive.box<Preference>('prefBox').put(
                        'alignTheme',
                        Preference(
                          value: newAlignType.first.getName(),
                        ));
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Color theme: '),
                DropdownButtonHideUnderline(
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
              ],
            ),
            MaterialButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ResetAppDialog();
                  },
                );
              },
              child: const Text(
                'RESET APP',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
