import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/preference.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/quiz_dialog_screen.dart';
import 'package:flutter_quizzer/screens/settings_dialog.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:flutter_quizzer/util/sort_quiz.dart';
import 'package:flutter_quizzer/widgets/quizzes/quiz_sort_dropdown.dart';
import 'package:flutter_quizzer/widgets/quizzes/quiz_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final quizBox = Hive.box<Quiz>('quizBox');

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

  AlertDialog showQuizDeleteDialog(quizId) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Are you sure you want to delete this quiz?\n",
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoMono(fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  deleteQuiz(quizId);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 12.0,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  'Yes',
                  style: GoogleFonts.jost(),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  elevation: 12.0,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  'No',
                  style: GoogleFonts.jost(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
      SnackBar(
        content: Text(
          'Quiz deleted!',
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

  ActionPane getActionPane(
    Function(String) deleteQuiz,
    Function(FormType, {Quiz quiz, String quizId}) showQuizDialog,
    String quizId,
    Quiz quiz,
  ) {
    return ActionPane(
      motion: const DrawerMotion(),
      extentRatio: 0.4,
      children: [
        SlidableAction(
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (context) {
                return showQuizDeleteDialog(quizId);
              },
            );
          },
          icon: Icons.delete,
          backgroundColor: Colors.red,
        ),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AlignType alignType = context.watch<AlignProvider>().alignType;
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();
    QuizSortType sortType = context.watch<QuizSortTypeProvider>().quizSortType;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuizWiz!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          QuizSortDropdown(
            sortType: sortType,
            onChanged: (QuizSortType newQuizSortType) {
              setState(() {
                context.read<QuizSortTypeProvider>().quizSortType =
                    newQuizSortType;
                Hive.box<Preference>('prefBox').put(
                  'quizSortType',
                  Preference(value: newQuizSortType.getName()),
                );
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return const SettingsDialog();
                },
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'New Quiz',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        icon: const Icon(Icons.add),
        onPressed: () {
          showQuizDialog(FormType.create);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: themeColor[100],
        child: ValueListenableBuilder(
            valueListenable: Hive.box<Quiz>('quizBox').listenable(),
            builder: (context, quizzes, _) {
              final List sortedIds = sortType.sortQuizIds(quizzes);

              if (sortedIds.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'You have no quizzes. Add a quiz below!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Icon(Icons.arrow_downward_rounded, size: 40),
                    ],
                  ),
                );
              }

              return ShaderMask(
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
                        0.03,
                        0.91,
                        1.0
                      ]).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: ListView.builder(
                  itemCount: sortedIds.length + 1,
                  itemBuilder: (context, index) {
                    // whitespace at the end
                    if (index == sortedIds.length) {
                      return const SizedBox(height: 65);
                    }

                    final quizId = sortedIds[index];
                    final quiz = quizzes.get(quizId)!;
                    final questionBox = Hive.box<Question>('questionBox');
                    int quizSize = questionBox.values.where((question) {
                      return question.quizId == quizId;
                    }).length;

                    void modifyCount(int change) {
                      setState(() {
                        quizSize += change;
                      });
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        right: alignType == AlignType.left ? 40.0 : 0,
                        left: alignType == AlignType.right ? 40.0 : 0,
                      ),
                      child: Slidable(
                        startActionPane: alignType == AlignType.left
                            ? getActionPane(
                                deleteQuiz, showQuizDialog, quizId, quiz)
                            : null,
                        endActionPane: alignType == AlignType.right
                            ? getActionPane(
                                deleteQuiz, showQuizDialog, quizId, quiz)
                            : null,
                        child: QuizTile(
                          quiz: quiz,
                          quizId: quizId,
                          modifyCount: modifyCount,
                          quizSize: quizSize,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
