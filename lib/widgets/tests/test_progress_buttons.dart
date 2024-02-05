import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:provider/provider.dart';

class ProgressButtonOverlays extends StatelessWidget {
  final Widget child;
  final bool sorting;
  final String questionKey;
  final void Function(String) knowQuestion;
  final void Function(String) dontKnowQuestion;
  final void Function(String) nextQuestion;

  const ProgressButtonOverlays({
    super.key,
    required this.child,
    required this.sorting,
    required this.questionKey,
    required this.knowQuestion,
    required this.dontKnowQuestion,
    required this.nextQuestion,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    return Stack(
      children: [
        child,
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(bottom: 10, right: 16),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: themeColor[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 40,
              onPressed: () {
                if (sorting) {
                  knowQuestion(questionKey);
                } else {
                  nextQuestion(questionKey);
                }
              },
              icon: Icon(
                Icons.check_rounded,
                color: themeColor[800],
              ),
            ),
          ),
        ),
        sorting
            ? Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(bottom: 10, left: 12),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: themeColor[200],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 40,
                    onPressed: () {
                      dontKnowQuestion(questionKey);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: themeColor[800],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
