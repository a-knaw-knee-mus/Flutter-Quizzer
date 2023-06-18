import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/util/colors.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/question_dialog_screen.dart';
import 'package:flutter_quizzer/util/sort_question.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            Text(quiz.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.fade,
                )),
          ],
        ),
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
                onChanged: (QuestionSortType? newSortType) {
                  setState(() {
                    sortType = newSortType!;
                  });
                },
                items: QuestionSortType.values.map((QuestionSortType s) {
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
          final List sortedIds = sortType.sortQuestionIds(questions);
          final List questionKeys = sortedIds.where((key) {
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
                  child: Card(
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
                        question.term,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        question.definition,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
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
