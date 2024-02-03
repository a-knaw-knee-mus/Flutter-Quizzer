import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum QuestionSortType {
  termAsc,
  termDesc,
  createdDateAsc,
  createdDateDesc,
  updatedDateAsc,
  updatedDateDesc,
}

extension QuestionSortExtension on QuestionSortType {
  String get name => describeEnum(this);

  Widget getDisplayWidget(Color textColor) {
    switch (this) {
      case QuestionSortType.termAsc:
        return Row(
          children: [
            const Icon(Icons.arrow_upward_rounded),
            Text(' Term', style: TextStyle(color: textColor)),
          ],
        );
      case QuestionSortType.termDesc:
        return Row(
          children: [
            const Icon(Icons.arrow_downward_rounded),
            Text(' Term', style: TextStyle(color: textColor)),
          ],
        );
      case QuestionSortType.createdDateAsc:
        return Row(
          children: [
            const Icon(Icons.arrow_upward_rounded),
            Text(' Created', style: TextStyle(color: textColor)),
          ],
        );
      case QuestionSortType.createdDateDesc:
        return Row(
          children: [
            const Icon(Icons.arrow_downward_rounded),
            Text(' Created', style: TextStyle(color: textColor)),
          ],
        );
      case QuestionSortType.updatedDateAsc:
        return Row(
          children: [
            const Icon(Icons.arrow_upward_rounded),
            Text(' Updated', style: TextStyle(color: textColor)),
          ],
        );
      case QuestionSortType.updatedDateDesc:
        return Row(
          children: [
            const Icon(Icons.arrow_downward_rounded),
            Text(' Updated', style: TextStyle(color: textColor)),
          ],
        );
      default:
        return Row(
          children: [
            const Icon(Icons.close),
            Text(' Invalid Sort Type', style: TextStyle(color: textColor)),
          ],
        );
    }
  }

  List sortQuestionIds(Box<Question> questions) {
    return questions.keys.toList()
      ..sort((a, b) {
        Question quizA = questions.get(a)!;
        Question quizB = questions.get(b)!;

        switch (this) {
          case (QuestionSortType.termAsc):
            {
              return quizA.term
                  .toLowerCase()
                  .compareTo(quizB.term.toLowerCase());
            }
          case (QuestionSortType.termDesc):
            {
              return quizB.term
                  .toLowerCase()
                  .compareTo(quizA.term.toLowerCase());
            }
          case (QuestionSortType.createdDateAsc):
            {
              return quizB.createdAt.compareTo(quizA.createdAt);
            }
          case (QuestionSortType.createdDateDesc):
            {
              return quizA.createdAt.compareTo(quizB.createdAt);
            }
          case (QuestionSortType.updatedDateAsc):
            {
              return quizB.updatedAt.compareTo(quizA.updatedAt);
            }
          case (QuestionSortType.updatedDateDesc):
            {
              return quizA.updatedAt.compareTo(quizB.updatedAt);
            }
          default:
            {
              return a;
            }
        }
      });
  }

  String getName() {
    switch (this) {
      case QuestionSortType.termAsc:
        return 'termAsc';
      case QuestionSortType.termDesc:
        return 'termDesc';
      case QuestionSortType.createdDateAsc:
        return 'createdDateAsc';
      case QuestionSortType.createdDateDesc:
        return 'createdDateDesc';
      case QuestionSortType.updatedDateAsc:
        return 'updatedDateAsc';
      case QuestionSortType.updatedDateDesc:
        return 'updatedDateDesc';
      default:
        return 'termAsc';
    }
  }

  static QuestionSortType getQuestionSortTypeFromString(String questionSortType) {
    switch (questionSortType) {
      case 'termAsc':
        return QuestionSortType.termAsc;
      case 'termDesc':
        return QuestionSortType.termDesc;
      case 'createdDateAsc':
        return QuestionSortType.createdDateAsc;
      case 'createdDateDesc':
        return QuestionSortType.createdDateDesc;
      case 'updatedDateAsc':
        return QuestionSortType.updatedDateAsc;
      case 'updatedDateDesc':
        return QuestionSortType.updatedDateDesc;
      default:
        return QuestionSortType.termAsc;
    }
  }
}