import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/screens/test_screen.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class QuestionCarousel extends StatefulWidget {
  final List questionKeys;
  final bool starredOnly;

  const QuestionCarousel({
    super.key,
    required this.questionKeys,
    required this.starredOnly,
  });

  @override
  State<QuestionCarousel> createState() => _QuestionCarouselState();
}

class _QuestionCarouselState extends State<QuestionCarousel> {
  final controller = PageController(viewportFraction: 0.8, initialPage: 0);
  final questionBox = Hive.box<Question>('questionBox');
  int currCarouselPage = 0;

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();
    List questionKeysFiltered = widget.questionKeys;
    if (widget.starredOnly) {
      questionKeysFiltered = widget.questionKeys
          .where(
            (key) => questionBox.get(key)!.isStarred,
          )
          .toList();
    }
    final carouselLength = questionKeysFiltered.length;
    if (carouselLength < 1) return Container();

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: 'Skip to start',
                child: IconButton(
                  onPressed: () => controller.jumpToPage(0),
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
              ),
              Text(
                "${widget.starredOnly ? 'Starred ' : ''}Term ${currCarouselPage + 1}/$carouselLength",
                style: TextStyle(
                  fontSize: 15,
                  color: themeColor[800],
                ),
              ),
              Tooltip(
                message: 'Skip to end',
                child: IconButton(
                  onPressed: () => controller.jumpToPage(carouselLength - 1),
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 170,
                  child: PageView.builder(
                    controller: controller,
                    onPageChanged: (value) {
                      setState(() => currCarouselPage = value);
                    },
                    itemCount: carouselLength,
                    itemBuilder: (_, index) {
                      index %= carouselLength;
                      Question question =
                          questionBox.get(questionKeysFiltered[index])!;
                      FlipCardController flipCon = FlipCardController();
                      return AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: currCarouselPage == index ? 1 : 0.90,
                        child: FlipCard(
                          speed: 250,
                          controller: flipCon,
                          direction: FlipDirection.VERTICAL,
                          side: CardSide.BACK,
                          back: TestExpandButton(
                            questionKeys: widget.questionKeys,
                            card: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: themeColor[200],
                              ),
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      question.term,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: themeColor[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          front: TestExpandButton(
                            questionKeys: widget.questionKeys,
                            card: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: themeColor[200],
                              ),
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      question.definition,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: themeColor[800],
                                        fontWeight: FontWeight.w400,
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
                SmoothPageIndicator(
                  controller: controller,
                  count: carouselLength,
                  effect: ScrollingDotsEffect(
                    activeStrokeWidth: 3,
                    activeDotScale: 1.2,
                    maxVisibleDots: 5,
                    spacing: 10,
                    dotHeight: 12,
                    dotWidth: 12,
                    fixedCenter: true,
                    dotColor: themeColor,
                    activeDotColor: themeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TestExpandButton extends StatelessWidget {
  final Widget card;
  final List questionKeys;

  const TestExpandButton(
      {super.key, required this.card, required this.questionKeys});

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    return Stack(
      children: <Widget>[
        card,
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.only(bottom: 18, right: 18),
          child: Container(
            alignment: Alignment.center,
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: themeColor[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return TestScreen(questionKeys: questionKeys);
                  }),
                );
              },
              icon: Icon(
                Icons.fullscreen_rounded,
                color: themeColor[800],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
