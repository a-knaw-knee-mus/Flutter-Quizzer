import 'package:flutter/material.dart';
import 'package:flutter_quizzer/util/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
        ),
        title: Text(
          term,
          style: GoogleFonts.jost(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          definition,
          style: GoogleFonts.jost(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
