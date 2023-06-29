import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class QuestionTile extends StatelessWidget {
  final String questionId;
  final Question question;

  const QuestionTile({
    super.key,
    required this.questionId,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final questionBox = Hive.box<Question>('questionBox');
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();
    AlignType alignType = context.watch<AlignProvider>().alignType;

    void toggleStarred() {
      questionBox.put(
        questionId,
        Question(
          term: question.term,
          definition: question.definition,
          quizId: question.quizId,
          createdAt: question.createdAt,
          updatedAt: question.updatedAt,
          isStarred: !question.isStarred,
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 12,
      color: themeColor[300],
      shape: RoundedRectangleBorder(
        borderRadius: alignType == AlignType.left
            ? const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: EdgeInsets.only(
          left: alignType == AlignType.left ? 0 : 16,
          right: alignType == AlignType.right ? 0 : 16,
        ),
        trailing: alignType == AlignType.left
            ? const Icon(
                Icons.arrow_forward_ios_rounded,
              )
            : IconButton(
                onPressed: () {
                  toggleStarred();
                },
                icon: Icon(question.isStarred
                    ? Icons.star_rate_rounded
                    : Icons.star_border_rounded),
                color: themeColor[500],
                iconSize: 35,
              ),
        leading: alignType == AlignType.right
            ? const Icon(
                Icons.arrow_back_ios_rounded,
              )
            : IconButton(
                onPressed: () {
                  toggleStarred();
                },
                icon: Icon(question.isStarred
                    ? Icons.star_rate_rounded
                    : Icons.star_border_rounded),
                color: themeColor[500],
                iconSize: 35,
              ),
        title: Text(
          question.term,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          question.definition,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
