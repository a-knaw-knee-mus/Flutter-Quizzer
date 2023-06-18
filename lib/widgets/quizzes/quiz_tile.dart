import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/questions_screen.dart';
import 'package:flutter_quizzer/util/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Card(
      margin: EdgeInsets.zero,
      elevation: 12,
      color: primary[400],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
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
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
        ),
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
                  color: primary[500],
                  border: Border.all(color: primary[900]!, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  '$quizSize term${quizSize != 1 ? 's' : ''}',
                  style: GoogleFonts.jost(
                    color: primary[100],
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
