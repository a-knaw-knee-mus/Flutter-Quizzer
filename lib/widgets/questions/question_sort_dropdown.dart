import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/util/sort_question.dart';

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
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: sortType.getDisplayWidget(Colors.white),
        iconStyleData: const IconStyleData(
          iconEnabledColor: Colors.white,
          icon: Icon(Icons.sort),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
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
