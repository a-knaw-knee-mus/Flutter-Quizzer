import 'package:flutter/material.dart';
import 'package:flutter_quizzer/types/form_types.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/question_dialog_screen.dart';
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

  void saveNewQuestion(String term, String definition,) {
    setState(() {
      questionBox.put(
        const Uuid().v1(),
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

  void editQuestion(String term, String definition, String questionId, DateTime ogCreatedAt,) {
    setState(() {
      questionBox.put(
        questionId,
        Question(
          term: term,
          definition: definition,
          quizId: widget.quizId,
          createdAt: ogCreatedAt,
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

  void showQuestionDialog(FormType dialogType,
      {String? questionId, Question? question}) {
    showDialog(
      context: context,
      builder: (context) {
        return QuestionDialog(
          context: context,
          saveNewQuestion: saveNewQuestion,
          editQuestion: editQuestion,
          quizName: quiz.name,
          formType: dialogType,
          questionId: questionId,
          question: question,
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
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New Question'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showQuestionDialog(FormType.create);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              Question question = questionBox.get(questionId)!;

              return Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          deleteQuestion(questionId);
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          showQuestionDialog(
                            FormType.edit,
                            questionId: questionId,
                            question: question,
                          );
                        },
                        icon: Icons.edit,
                        backgroundColor: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                          Text('Definition: ${question.definition}'),
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
    );
  }
}
