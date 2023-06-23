import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/preference.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ResetAppDialog extends StatelessWidget {
  const ResetAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final quizBox = Hive.box<Quiz>('quizBox');
    final questionBox = Hive.box<Question>('questionBox');
    final prefBox = Hive.box<Preference>('prefBox');

    return AlertDialog(
      title: const Text('RESET APP'),
      content: const Text(
          'Are you sure you would like to reset the app? All of your quizzes, questions, and app preferences will be deleted/reset.'),
      actions: [
        TextButton(
            onPressed: () {
              quizBox.clear();
              questionBox.clear();
              prefBox.clear();
              context.read<ColorProvider>().color = ColorType.purple;
              context.read<AlignProvider>().alignType = AlignType.left;
              Navigator.pop(context);
            },
            child: const Text('Agree')),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
      ],
    );
  }
}
