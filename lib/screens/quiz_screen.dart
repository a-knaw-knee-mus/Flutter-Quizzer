import 'package:flutter/material.dart';
import 'package:flutter_quizzer/data/question.dart';
import 'package:flutter_quizzer/data/quiz.dart';
import 'package:flutter_quizzer/screens/new_question_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final quizBox = Hive.box<Quiz>('quizBox');
  late final Quiz quiz = quizBox.get(widget.quizId)!;
  final questionBox = Hive.box<Question>('questionBox');

  void saveNewQuestion(String term, String definition) {
    String uuid = const Uuid().v1();

    setState(() {
      questionBox.put(
        uuid,
        Question(
          term: term,
          definition: definition,
          quizId: widget.quizId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });
  }

  void deleteQuestion(String questionId) {
    setState(() {
      questionBox.delete(questionId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Term deleted!',
        ),
        duration: Duration(
          milliseconds: 1500,
        ),
        showCloseIcon: true,
        backgroundColor: Colors.red,
      ),
    );
  }

  void showQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return NewQuestionDialog(
          saveNewQuestion: saveNewQuestion,
          quizName: quiz.name,
          context: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${quiz.name}: ${quiz.description}'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Question>('questionBox').listenable(),
        builder: (context, questions, _) {
          final List questionKeys = questions.keys.where((key) {
            Question question = questionBox.get(key)!;
            if (question.quizId == widget.quizId) {
              return true;
            }
            return false;
          }).toList();
          return ListView.builder(
            itemCount: questionKeys.length,
            itemBuilder: (context, index) {
              final questionId = questionKeys[index];
              final question = questionBox.get(questionId)!;

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
                          deleteQuestion(questionId);
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(12),
                      )
                    ],
                  ),
                  child: Card(
                    elevation: 12,
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Term: ${question.term}'),
                          Text('Definition: ${question.definition}')
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New Question'),
        icon: const Icon(Icons.add),
        onPressed: showQuestionDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
