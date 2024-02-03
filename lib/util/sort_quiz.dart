import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum QuizSortType {
  nameAsc,
  nameDesc,
  createdDateAsc,
  createdDateDesc,
  updatedDateAsc,
  updatedDateDesc,
}

extension QuizSortExtension on QuizSortType {
  String get name => describeEnum(this);

  Widget getDisplayWidget(Color textColor) {
    switch (this) {
      case QuizSortType.nameAsc:
        return Row(
          children: [
            const Icon(Icons.arrow_upward_rounded),
            Text(' Name', style: TextStyle(color: textColor)),
          ],
        );
      case QuizSortType.nameDesc:
        return Row(
          children: [
            const Icon(Icons.arrow_downward_rounded),
            Text(' Name', style: TextStyle(color: textColor)),
          ],
        );
      case QuizSortType.createdDateAsc:
        return Row(
          children: [
            const Icon(Icons.arrow_upward_rounded),
            Text(' Created', style: TextStyle(color: textColor)),
          ],
        );
      case QuizSortType.createdDateDesc:
        return Row(
          children: [
            const Icon(Icons.arrow_downward_rounded),
            Text(' Created', style: TextStyle(color: textColor)),
          ],
        );
      case QuizSortType.updatedDateAsc:
        return Row(
          children: [
            const Icon(Icons.arrow_upward_rounded),
            Text(' Updated', style: TextStyle(color: textColor)),
          ],
        );
      case QuizSortType.updatedDateDesc:
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
            Text('Invalid Sort Type', style: TextStyle(color: textColor)),
          ],
        );
    }
  }

  List sortQuizIds(Box<Quiz> quizzes) {
    return quizzes.keys.toList()
      ..sort((a, b) {
        Quiz quizA = quizzes.get(a)!;
        Quiz quizB = quizzes.get(b)!;

        switch (this) {
          case (QuizSortType.nameAsc):
            {
              return quizA.name
                  .toLowerCase()
                  .compareTo(quizB.name.toLowerCase());
            }
          case (QuizSortType.nameDesc):
            {
              return quizB.name
                  .toLowerCase()
                  .compareTo(quizA.name.toLowerCase());
            }
          case (QuizSortType.createdDateAsc):
            {
              return quizB.createdAt.compareTo(quizA.createdAt);
            }
          case (QuizSortType.createdDateDesc):
            {
              return quizA.createdAt.compareTo(quizB.createdAt);
            }
          case (QuizSortType.updatedDateAsc):
            {
              return quizB.updatedAt.compareTo(quizA.updatedAt);
            }
          case (QuizSortType.updatedDateDesc):
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
      case QuizSortType.nameAsc:
        return 'nameAsc';
      case QuizSortType.nameDesc:
        return 'nameDesc';
      case QuizSortType.createdDateAsc:
        return 'createdDateAsc';
      case QuizSortType.createdDateDesc:
        return 'createdDateDesc';
      case QuizSortType.updatedDateAsc:
        return 'updatedDateAsc';
      case QuizSortType.updatedDateDesc:
        return 'updatedDateDesc';
      default:
        return 'nameAsc';
    }
  }

  static QuizSortType getQuizSortTypeFromString(String quizSortType) {
    quizSortType = quizSortType.toLowerCase();

    switch (quizSortType) {
      case 'nameAsc':
        return QuizSortType.nameAsc;
      case 'nameDesc':
        return QuizSortType.nameDesc;
      case 'createdDateAsc':
        return QuizSortType.createdDateAsc;
      case 'createdDateDesc':
        return QuizSortType.createdDateDesc;
      case 'updatedDateAsc':
        return QuizSortType.updatedDateAsc;
      case 'updatedDateDesc':
        return QuizSortType.updatedDateDesc;
      default:
        return QuizSortType.nameAsc;
    }
  }
}
