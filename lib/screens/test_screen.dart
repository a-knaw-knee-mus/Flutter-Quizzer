import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/screens/test_settings_dialog.dart';
import 'package:flutter_quizzer/widgets/tests/test_progress_buttons.dart';
import 'package:flutter_quizzer/widgets/tests/test_summary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  final List questionKeys;

  const TestScreen({
    super.key,
    required this.questionKeys,
  });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool sorting = true;
  bool termStart = true;
  bool starredOnly = false;
  final questionBox = Hive.box<Question>('questionBox');
  int currCardIndex = 0;
  List know = []; // store keys of questions you know
  List dontKnow = []; // store keys of questions you don't know
  List prevQuestionKeyList = [];
  List shuffledIndexList = [];
  bool testDone = false;

  void toggleSorting(bool val) {
    setState(() {
      sorting = val;
      currCardIndex = 0;
      know.clear();
      dontKnow.clear();
      prevQuestionKeyList = [];
    });
  }

  void setTermStart(bool val) {
    setState(() {
      termStart = val;
    });
  }

  void setStarredOnly(bool val) {
    setState(() {
      starredOnly = val;
      currCardIndex = 0;
      know.clear();
      dontKnow.clear();
      prevQuestionKeyList = [];
    });
  }

  void knowQuestion(String key) {
    setState(() {
      know.add(key);
      prevQuestionKeyList.add(key);
      currCardIndex++;
    });
  }

  void dontKnowQuestion(String key) {
    setState(() {
      dontKnow.add(key);
      prevQuestionKeyList.add(key);
      currCardIndex++;
    });
  }

  void nextQuestion(String key) {
    setState(() {
      prevQuestionKeyList.add(key);
      currCardIndex++;
    });
  }

  void previousQuestion() {
    if (know.isNotEmpty && know.last == prevQuestionKeyList.last) {
      know.removeLast();
    } else if (dontKnow.isNotEmpty &&
        dontKnow.last == prevQuestionKeyList.last) {
      dontKnow.removeLast();
    }
    prevQuestionKeyList.removeLast();
    currCardIndex--;
    setState(() {});
  }

  void shuffleTerms() {
    setState(() {
      currCardIndex = 0;
      know.clear();
      dontKnow.clear();
      prevQuestionKeyList = [];
      shuffledIndexList.shuffle();
    });
  }

  void restartTest() {
    setState(() {
      currCardIndex = 0;
      know.clear();
      dontKnow.clear();
      prevQuestionKeyList = [];
      shuffledIndexList.clear();
      for (int i = 0; i < widget.questionKeys.length; i++) {
        shuffledIndexList.add(i);
      }
    });
  }

  @override
  void initState() {
    for (int i = 0; i < widget.questionKeys.length; i++) {
      shuffledIndexList.add(i);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();
    FlipCardController flipCon = FlipCardController();

    List filteredKeys = widget.questionKeys.where((key) {
      Question q = questionBox.get(key)!;
      if (!starredOnly) return true;
      if (starredOnly && q.isStarred) return true;
      return false;
    }).toList();

    // shuffle cards
    List shuffledIndexListFiltered = shuffledIndexList.where(
      (index) {
        if (index >= filteredKeys.length) return false;
        return true;
      },
    ).toList();
    List questions = filteredKeys.map((key) {
      return questionBox.get(key);
    }).toList();
    List numbers = shuffledIndexListFiltered;
    final Map<int, Question> mappings = {
      for (int i = 0; i < numbers.length; i++) numbers[i]: questions[i]
    };
    numbers.sort();
    questions = [for (int number in numbers) mappings[number]];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          filteredKeys.isNotEmpty
              ? '${currCardIndex != filteredKeys.length ? (currCardIndex + 1) : (currCardIndex)}/${questions.length}'
              : 'NO STARRED QUESTIONS',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) {
                  return TestSettingsDialog(
                    sorting: sorting,
                    starredOnly: starredOnly,
                    termStart: termStart,
                    restartTest: restartTest,
                    toggleSorting: toggleSorting,
                    setTermStart: setTermStart,
                    setStarredOnly: setStarredOnly,
                    shuffleTerms: shuffleTerms,
                  );
                },
                enableDrag: true,
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Container(
        color: themeColor[100],
        child: filteredKeys.isNotEmpty
            ? Column(
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: (currCardIndex) / (filteredKeys.length),
                    ),
                    builder: (context, value, _) =>
                        LinearProgressIndicator(value: value),
                  ),
                  currCardIndex != filteredKeys.length
                      ? Column(
                          children: [
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              tween: Tween<double>(
                                begin: 0,
                                end: (currCardIndex) / (filteredKeys.length),
                              ),
                              builder: (context, value, _) =>
                                  LinearProgressIndicator(value: value),
                            ),
                            sorting
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.orange[300]!,
                                            border: Border.all(
                                                color: Colors.orange[700]!,
                                                width: 1.5),
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(19),
                                              bottomRight: Radius.circular(19),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${dontKnow.length}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange[900]!,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.green[300]!,
                                            border: Border.all(
                                                color: Colors.green[700]!,
                                                width: 1.5),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(19),
                                              bottomLeft: Radius.circular(19),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${know.length}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[900]!,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: 520,
                                  width: 350,
                                  child: FlipCard(
                                    animationDuration:
                                        const Duration(milliseconds: 250),
                                    controller: flipCon,
                                    rotateSide: RotateSide.bottom,
                                    axis: FlipAxis.horizontal,
                                    onTapFlipping: true,
                                    frontWidget: ProgressButtonOverlays(
                                      questionKey: filteredKeys[currCardIndex],
                                      sorting: sorting,
                                      knowQuestion: knowQuestion,
                                      dontKnowQuestion: dontKnowQuestion,
                                      nextQuestion: nextQuestion,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                              color: themeColor[700]!,
                                              width: 1.5),
                                          color: themeColor[200],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: Center(
                                          child: Text(
                                            termStart
                                                ? questions[currCardIndex].term
                                                : questions[currCardIndex]
                                                    .definition,
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: themeColor[800],
                                              fontWeight: termStart
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    backWidget: ProgressButtonOverlays(
                                      questionKey: filteredKeys[currCardIndex],
                                      sorting: sorting,
                                      knowQuestion: knowQuestion,
                                      dontKnowQuestion: dontKnowQuestion,
                                      nextQuestion: nextQuestion,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                              color: themeColor[700]!,
                                              width: 1.5),
                                          color: themeColor[200],
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: Center(
                                          child: Text(
                                            !termStart
                                                ? questions[currCardIndex].term
                                                : questions[currCardIndex]
                                                    .definition,
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: themeColor[800],
                                              fontWeight: !termStart
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            currCardIndex > 0
                                ? Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 45.0, top: 20.0),
                                      child: IconButton(
                                        onPressed: () => previousQuestion(),
                                        icon: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: themeColor[800],
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : TestSummary(
                          knownQuestions: know,
                          dontKnowQuestions: dontKnow,
                          totalQuestions: filteredKeys,
                          sorting: sorting,
                        )
                ],
              )
            : Container(),
      ),
    );
  }
}
