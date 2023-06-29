import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
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
import 'package:provider/provider.dart';
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
  bool starredOnly = false;

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
          isStarred: false,
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
    bool isStarred =
        Hive.box<Question>('questionBox').get(questionId)!.isStarred;
    setState(() {
      questionBox.put(
        questionId,
        Question(
          term: term,
          definition: definition,
          quizId: widget.quizId,
          createdAt: ogCreatedAt,
          updatedAt: DateTime.now(),
          isStarred: isStarred,
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

  ActionPane getActionPane(
    Function(String) deleteQuestion,
    Function(FormType, {Question question, String questionId})
        showQuestionDialog,
    String questionId,
    Question question,
  ) {
    return ActionPane(
      extentRatio: 0.4,
      motion: const DrawerMotion(),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    AlignType alignType = context.watch<AlignProvider>().alignType;
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                quiz.name,
                style: const TextStyle(
                  fontSize: 22,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                quiz.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
        actions: [
          QuestionSortDropdown(
            sortType: sortType,
            onChanged: (QuestionSortType newSortType) {
              setState(() {
                sortType = newSortType;
              });
            },
          ),
          IconButton(
            icon: starredOnly
                ? const Icon(Icons.star_rate_rounded)
                : const Icon(Icons.star_border_rounded),
            tooltip: 'Toggle starred questions',
            onPressed: () {
              setState(() {
                starredOnly = !starredOnly;
              });
            },
          )
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
      body: Container(
        color: themeColor[100],
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Question>('questionBox').listenable(),
          builder: (context, questions, _) {
            final List sortedIds =
                sortType.sortQuestionIds(questions); // all question keys sorted
            final List questionKeys = sortedIds.where((key) {
              // question keys part of this quiz
              Question question = questionBox.get(key)!;
              if (question.quizId == widget.quizId) {
                return true;
              }
              return false;
            }).toList();
      
            if (questionKeys.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Your quiz is empty. Add a question below!',
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
      
            final List questionKeysStarred = questionKeys
                .where((key) => questionBox.get(key)!.isStarred)
                .toList();
            final List questionKeysUnstarred = questionKeys
                .where((key) => !questionKeysStarred.contains(key))
                .toList();
      
            // list of keys in quiz but showing starred terms first
            final List keysStarredUnstarred = [
              ...questionKeysStarred,
              ...questionKeysUnstarred
            ];
      
            return Column(
              children: [
                QuestionCarousel(
                  questionKeys: questionKeys,
                  starredOnly: starredOnly,
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
                          Colors.red // arbitrary
                        ],
                        stops: [0.0, 0.04, 0.88, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.builder(
                      itemCount: starredOnly
                          ? keysStarredUnstarred.length + 1
                          : questionKeys.length + 1,
                      itemBuilder: (context, index) {
                        // whitespace at the end
                        if (starredOnly && index == keysStarredUnstarred.length) {
                          return const SizedBox(height: 65);
                        }
                        if (!starredOnly && index == questionKeys.length) {
                          return const SizedBox(height: 65);
                        }
                      
                        final questionId = starredOnly
                            ? keysStarredUnstarred[index]
                            : questionKeys[index];
                        Question question = questionBox.get(questionId)!;
                      
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20.0,
                                right: alignType == AlignType.left ? 50.0 : 0,
                                left: alignType == AlignType.right ? 50.0 : 0,
                              ),
                              child: Slidable(
                                startActionPane: alignType == AlignType.left
                                    ? getActionPane(deleteQuestion,
                                        showQuestionDialog, questionId, question)
                                    : null,
                                endActionPane: alignType == AlignType.right
                                    ? getActionPane(deleteQuestion,
                                        showQuestionDialog, questionId, question)
                                    : null,
                                child: QuestionTile(
                                  question: question,
                                  questionId: questionId,
                                ),
                              ),
                            ),
                            starredOnly &&
                                    index == questionKeysStarred.length - 1 &&
                                    questionKeysUnstarred.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Divider(
                                      thickness: 2,
                                      color: themeColor[400],
                                      endIndent:
                                          (alignType == AlignType.left) ? 80 : 0,
                                      indent:
                                          (alignType == AlignType.right) ? 80 : 0,
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
