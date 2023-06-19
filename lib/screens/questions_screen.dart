import 'package:flutter/material.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/question_dialog_screen.dart';
import 'package:flutter_quizzer/util/sort_question.dart';
import 'package:flutter_quizzer/widgets/questions/question_carousel.dart';
import 'package:flutter_quizzer/widgets/questions/question_sort_dropdown.dart';
import 'package:flutter_quizzer/widgets/questions/question_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final void Function(int) modifyCount;

  const QuizScreen({
    super.key,
    required this.quizId,
    required this.modifyCount,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final quizBox = Hive.box<Quiz>('quizBox');
  late final Quiz quiz = quizBox.get(widget.quizId)!;
  final questionBox = Hive.box<Question>('questionBox');
  QuestionSortType sortType = QuestionSortType.termAsc;

  void saveNewQuestion(
    String term,
    String definition,
  ) {
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

    widget.modifyCount(1);
  }

  void editQuestion(
    String term,
    String definition,
    String questionId,
    DateTime ogCreatedAt,
  ) {
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

    widget.modifyCount(-1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Term deleted!',
          style: GoogleFonts.jost(),
        ),
        duration: const Duration(
          milliseconds: 1500,
        ),
        showCloseIcon: true,
        backgroundColor: Colors.red,
      ),
    );
  }

  void showQuestionDialog(
    FormType dialogType, {
    String? questionId,
    Question? question,
  }) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.name,
              style: const TextStyle(
                fontSize: 22,
              ),
              overflow: TextOverflow.fade,
            ),
            Text(
              quiz.description,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: QuestionSortDropdown(
              sortType: sortType,
              onChanged: (QuestionSortType newSortType) {
                setState(() {
                  sortType = newSortType;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'New Question',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          showQuestionDialog(FormType.create);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Question>('questionBox').listenable(),
        builder: (context, questions, _) {
          final List sortedIds = sortType.sortQuestionIds(questions);
          final List questionKeys = sortedIds.where((key) {
            Question question = questionBox.get(key)!;
            if (question.quizId == widget.quizId) {
              return true;
            }
            return false;
          }).toList();
          return Column(
            children: [
              QuestionCarousel(
                questionKeys: questionKeys,
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red, // arbitrary
                        Colors.transparent,
                        Colors.transparent,
                        Colors.red, // arbitrary
                      ],
                      stops: [
                        0.0,
                        0.04,
                        0.88,
                        1.0
                      ], // 10% purple, 80% transparent, 10% purple
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ListView.builder(
                    itemCount: questionKeys.length + 1,
                    itemBuilder: (context, index) {
                      if (index == questionKeys.length) {
                        return SizedBox(height: 65);
                      }

                      final questionId = questionKeys[index];
                      Question question = questionBox.get(questionId)!;

                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          right: 60.0,
                        ),
                        child: Slidable(
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.3,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  deleteQuestion(questionId);
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
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
                              ),
                            ],
                          ),
                          child: QuestionTile(
                            term: question.term,
                            definition: question.definition,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
