import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/questions_screen.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizTile extends StatelessWidget {
  final String quizId;
  final void Function(int) modifyCount;
  final Quiz quiz;
  final int quizSize;

  const QuizTile({
    super.key,
    required this.quizId,
    required this.modifyCount,
    required this.quiz,
    required this.quizSize,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();
    AlignType alignType = context.watch<AlignProvider>().alignType;

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
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return QuizScreen(
                quizId: quizId,
                modifyCount: modifyCount,
              );
            }),
          );
        },
        trailing: alignType == AlignType.left
            ? const Icon(
                Icons.arrow_forward_ios_rounded,
              )
            : null,
        leading: alignType == AlignType.right
            ? const Icon(
                Icons.arrow_back_ios_rounded,
              )
            : null,
        title: Text(
          quiz.name,
          style: GoogleFonts.jost(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.description,
              style: GoogleFonts.jost(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: themeColor[500],
                  border: Border.all(color: themeColor[900]!, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  '$quizSize term${quizSize != 1 ? 's' : ''}',
                  style: GoogleFonts.jost(
                    color: themeColor[100],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
