import 'package:flutter/material.dart';
import 'package:flutter_quizzer/data/quiz.dart';
import 'package:flutter_quizzer/screens/new_quiz_screen.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final quizBox = Hive.box<Quiz>('quizBox');

  void saveNewQuiz(quizName, quizDesc) {
    final quizBox = Hive.box<Quiz>('quizBox');
    String uuid = const Uuid().v1();

    setState(() {
      quizBox.put(
        uuid,
        Quiz(
          name: quizName,
          description: quizDesc,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });
  }

  void showQuizDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return NewQuizDialog(saveNewQuiz: saveNewQuiz, context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Quizzes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New Quiz'),
        icon: const Icon(Icons.add),
        onPressed: showQuizDialog,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: ListView.builder(
        itemCount: quizBox.length,
        itemBuilder: (context, index) {
          final quizId = quizBox.keyAt(index);
          final quiz = quizBox.getAt(index)!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print('click box $quizId');
              },
              child: Container(
                color: Colors.amber,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(quiz.name),
                    Text(quiz.description),
                    Text(quiz.createdAt.toString()),
                    Text(quiz.updatedAt.toString()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
