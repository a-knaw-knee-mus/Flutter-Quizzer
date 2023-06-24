import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/util/sort_question.dart';
import 'package:provider/provider.dart';

class QuestionSortDropdown extends StatelessWidget {
  final QuestionSortType sortType;
  final void Function(QuestionSortType) onChanged;

  const QuestionSortDropdown({
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
        iconStyleData: IconStyleData(
          icon: Container(),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: themeColor[100],
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onChanged: (QuestionSortType? newSortType) {
          onChanged(newSortType!);
        },
        items: QuestionSortType.values.map((QuestionSortType s) {
          return DropdownMenuItem(
            value: s,
            child: s.getDisplayWidget(Colors.black),
          );
        }).toList(),
      ),
    );
  }
}
