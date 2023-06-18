import 'package:flutter/material.dart';
import 'package:flutter_quizzer/util/colors.dart';

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
