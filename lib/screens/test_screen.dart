import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/screens/test_settings_dialog.dart';
import 'package:flutter_quizzer/widgets/tests/test_progress_buttons.dart';
import 'package:flutter_quizzer/widgets/tests/test_summary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

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
  List prevQuestionKeyList = []; // stored answered questions in a stack for undo
  AppinioSwiperController stackCon = AppinioSwiperController();

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

  void previousQuestion() {
    if (know.isNotEmpty && know.last == prevQuestionKeyList.last) {
      know.removeLast();
    } else if (dontKnow.isNotEmpty &&
        dontKnow.last == prevQuestionKeyList.last) {
      dontKnow.removeLast();
    }
    prevQuestionKeyList.removeLast();
    currCardIndex--;
    stackCon.unswipe();
    setState(() {});
  }

  void shuffleTerms() {
    // shuffle the cards and send these shuffled cards to a new duplicate test page
    widget.questionKeys.shuffle();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TestScreen(
          questionKeys: widget.questionKeys,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    List filteredKeys = widget.questionKeys.where((key) {
      Question q = questionBox.get(key)!;
      if (!starredOnly) return true;
      if (starredOnly && q.isStarred) return true;
      return false;
    }).toList();
    // at this point keys are filtered on if starred only or not, and shuffled if needed

    List<Question> questions = filteredKeys.map((key) {
      return questionBox.get(key)!;
    }).toList();

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
              ? '${starredOnly ? 'Starred ' : ''} ${currCardIndex != filteredKeys.length ? (currCardIndex) : (currCardIndex)}/${questions.length}'
              : 'No starred terms',
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
                    // progress bar
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
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Visibility(
                                // solved problems tracking
                                visible: sorting ? true : false,
                                maintainSize: false,
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
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 500,
                                    width: 320,
                                    child: AppinioSwiper(
                                      controller: stackCon,
                                      cardCount: questions.length,
                                      swipeOptions: SwipeOptions.only(
                                        up: false,
                                        down: false,
                                        left: sorting, // allow left swipe while sorting to allow 'don't know'
                                        right: true,
                                      ),
                                      onSwipeEnd: (int previousIndex,
                                          int _,
                                          SwiperActivity activity) {
                                        switch (activity) {
                                          case Swipe():
                                            if (activity.direction ==
                                                AxisDirection.right) {
                                              knowQuestion(
                                                  filteredKeys[previousIndex]);
                                            } else if (activity.direction ==
                                                AxisDirection.left) {
                                              dontKnowQuestion(
                                                  filteredKeys[previousIndex]);
                                            }
                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                      cardBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          // question stack
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: FlipCard(
                                            key: GlobalKey(),
                                            speed: 250,
                                            side: CardSide.BACK,
                                            direction: FlipDirection.VERTICAL,
                                            // set back as starting side so flipping animation flips from the bottom
                                            back: ProgressButtonOverlays(
                                              stackCon: stackCon,
                                              questionKey: filteredKeys[index],
                                              sorting: sorting,
                                              knowQuestion: knowQuestion,
                                              dontKnowQuestion:
                                                  dontKnowQuestion,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: themeColor[700]!,
                                                      width: 1.5),
                                                  color: themeColor[200],
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                        termStart
                                                            ? questions[index]
                                                                .term
                                                            : questions[index]
                                                                .definition,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          color:
                                                              themeColor[800],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            front: ProgressButtonOverlays(
                                              stackCon: stackCon,
                                              questionKey: filteredKeys[index],
                                              sorting: sorting,
                                              knowQuestion: knowQuestion,
                                              dontKnowQuestion:
                                                  dontKnowQuestion,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: themeColor[700]!,
                                                    width: 1.5,
                                                  ),
                                                  color: themeColor[200],
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                        !termStart
                                                            ? questions[index]
                                                                .term
                                                            : questions[index]
                                                                .definition,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          color:
                                                              themeColor[800],
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    // previous question button
                                    maintainInteractivity: false,
                                    visible: currCardIndex > 0 ? true : false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Align(
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
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
