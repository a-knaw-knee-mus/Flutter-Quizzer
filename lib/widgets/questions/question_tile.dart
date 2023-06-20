import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:provider/provider.dart';

class QuestionTile extends StatelessWidget {
  final String term;
  final String definition;

  const QuestionTile({
    super.key,
    required this.term,
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor = context.watch<ColorProvider>().color.getColorSwatch();
    AlignType alignType = context.watch<AlignProvider>().alignType;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 12,
      color: themeColor[400],
      shape: RoundedRectangleBorder(
        borderRadius: alignType == AlignType.left ? const BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ) : const BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: ListTile(
        trailing: alignType == AlignType.left ? const Icon(
          Icons.arrow_forward_ios_rounded,
        ) : null,
        leading: alignType == AlignType.right ? const Icon(
          Icons.arrow_back_ios_rounded,
        ) : null,
        title: Text(
          term,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          definition,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
