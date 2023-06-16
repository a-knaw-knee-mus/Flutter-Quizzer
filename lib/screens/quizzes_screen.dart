import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/data/question.dart';
import 'package:flutter_quizzer/data/quiz.dart';
import 'package:flutter_quizzer/screens/new_quiz_screen.dart';
import 'package:flutter_quizzer/screens/quiz_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  void deleteQuiz(String quizId) {
    setState(() {
      quizBox.delete(quizId);
      final questionBox = Hive.box<Question>('questionBox');
      for (String key in questionBox.keys) {
        if (questionBox.get(key)!.quizId == quizId) {
          questionBox.delete(key);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Quiz deleted!',
        ),
        duration: Duration(
          milliseconds: 1500,
        ),
        showCloseIcon: true,
        backgroundColor: Colors.red,
      ),
    );
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
          final quizId = quizBox.keyAt(index)!;
          final quiz = quizBox.getAt(index)!;

          return Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.15,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        deleteQuiz(quizId);
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(12),
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return QuizScreen(quizId: quizId);
                      }),
                    );
                  },
                  child: Card(
                    elevation: 12,
                    color: Colors.amber,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Name: ${quiz.name}'),
                          Text('Desc: ${quiz.description}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
