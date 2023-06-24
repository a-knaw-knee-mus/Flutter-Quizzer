import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/util/sort_quiz.dart';
import 'package:provider/provider.dart';

class QuizSortDropdown extends StatelessWidget {
  final QuizSortType sortType;
  final void Function(QuizSortType) onChanged;

  const QuizSortDropdown({
    super.key,
    required this.sortType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: sortType.getDisplayWidget(Colors.white),
        iconStyleData: const IconStyleData(
          iconEnabledColor: Colors.white,
          icon: Icon(Icons.sort),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: themeColor[100],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onChanged: (QuizSortType? newSortType) {
          onChanged(newSortType!);
        },
        items: QuizSortType.values.map((QuizSortType s) {
          return DropdownMenuItem(
            value: s,
            child: s.getDisplayWidget(Colors.black),
          );
        }).toList(),
      ),
    );
  }
}
