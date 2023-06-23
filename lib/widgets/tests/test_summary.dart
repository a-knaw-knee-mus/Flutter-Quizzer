import 'package:flutter/material.dart';
import 'package:flutter_quizzer/screens/test_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TestSummary extends StatelessWidget {
  final List knownQuestions;
  final List dontKnowQuestions;
  final List totalQuestions;
  final bool sorting;

  const TestSummary({
    super.key,
    required this.knownQuestions,
    required this.dontKnowQuestions,
    required this.totalQuestions,
    required this.sorting,
  });

  String getCompletionText(int questionsLength) {
    if (sorting) {
      final double correctRatio = knownQuestions.length / questionsLength;
      if (correctRatio >= 1) {
        return "Congratulations! You've mastered all the flashcards. Amazing work! Now you can confidently move on to more advanced topics or challenge yourself with new sets of flashcards.";
      } else if (correctRatio >= 0.8) {
        return "Great job! You're almost there. Just a few more flashcards to master. Keep up the good work and reinforce your knowledge.";
      } else if (correctRatio >= 0.7) {
        return "Well done! You have a solid understanding of most flashcards. Take some time to review the ones you found challenging to strengthen your grasp.";
      } else if (correctRatio >= 0.5) {
        return "Good effort! You're on the right track. Focus on the flashcards you struggled with and give them some extra attention.";
      } else {
        return "Keep practicing! You have room for improvement. Try reviewing the flashcards again to enhance your knowledge";
      }
    } else {
      return "Congratulations on completing the test! Take a moment to reflect on your performance and areas for further improvement.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 40,
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getCompletionText(totalQuestions.length),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 10.0,
                      progressColor: Colors.green[700],
                      backgroundColor: Colors.orange,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: knownQuestions.length / totalQuestions.length,
                      center: Text(
                        '${'${knownQuestions.length / totalQuestions.length * 100}'.split('.').first}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Know',
                                  style: TextStyle(
                                      color: Colors.green[800], fontSize: 20),
                                ),
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green[800]!, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${knownQuestions.length}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800]!,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Still learning',
                                  style: TextStyle(
                                      color: Colors.orange[800], fontSize: 20),
                                ),
                                Container(
                                  width: 50,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.orange[800]!, width: 1.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${dontKnowQuestions.length}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800]!,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            MaterialButton(
              child: const Text(
                'REDO FAILED QUESTIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return TestScreen(questionKeys: dontKnowQuestions);
                  }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
