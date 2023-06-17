import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/quiz_dialog_screen.dart';
import 'package:flutter_quizzer/screens/questions_screen.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:flutter_quizzer/util/sort_quiz.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final quizBox = Hive.box<Quiz>('quizBox');
  QuizSortType sortType = QuizSortType.nameAsc;

  void saveNewQuiz(
    String name,
    String desc,
  ) {
    setState(() {
      quizBox.put(
        const Uuid().v1(),
        Quiz(
          name: name,
          description: desc,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });
  }

  void editQuiz(
    String name,
    String desc,
    String quizId,
    DateTime ogCreatedAt,
  ) {
    setState(() {
      quizBox.put(
        quizId,
        Quiz(
          name: name,
          description: desc,
          createdAt: ogCreatedAt,
          updatedAt: DateTime.now(),
        ),
      );
    });
  }

  void deleteQuiz(String quizId) {
    setState(() {
      quizBox.delete(quizId);
      // cascade delete
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

  void showQuizDialog(FormType dialogType, {String? quizId, Quiz? quiz}) {
    showDialog(
      context: context,
      builder: (context) {
        return QuizDialog(
          context: context,
          saveNewQuiz: saveNewQuiz,
          editQuiz: editQuiz,
          formType: dialogType,
          quizId: quizId,
          quiz: quiz,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quizzer!'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: sortType.getDisplayWidget(Colors.white),
                  iconStyleData: const IconStyleData(
                    iconEnabledColor: Colors.white,
                    icon: Icon(Icons.sort),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (QuizSortType? newSortType) {
                    setState(() {
                      sortType = newSortType!;
                    });
                  },
                  items: QuizSortType.values.map((QuizSortType s) {
                    return DropdownMenuItem(
                      value: s,
                      child: s.getDisplayWidget(Colors.black),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('New Quiz'),
          icon: const Icon(Icons.add),
          onPressed: () {
            showQuizDialog(FormType.create);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: Hive.box<Quiz>('quizBox').listenable(),
                  builder: (context, quizzes, _) {
                    final List sortedIds = sortType.sortQuizIds(quizzes);
                    return ListView.builder(
                      itemCount: sortedIds.length,
                      itemBuilder: (context, index) {
                        final quizId = sortedIds[index];
                        final quiz = quizzes.get(quizId)!;

                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.15,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    showQuizDialog(
                                      FormType.edit,
                                      quiz: quiz,
                                      quizId: quizId,
                                    );
                                  },
                                  icon: Icons.edit,
                                  backgroundColor: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ],
                            ),
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
                                ),
                              ],
                            ),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              child: ListTile(
                                isThreeLine: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return QuizScreen(quizId: quizId);
                                    }),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                tileColor: Colors.purpleAccent,
                                trailing:
                                    const Icon(Icons.arrow_forward_ios_rounded),
                                title: Text(quiz.name),
                                subtitle: Text(
                                    '${quiz.description} - ${quiz.createdAt} - ${quiz.updatedAt}'),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
