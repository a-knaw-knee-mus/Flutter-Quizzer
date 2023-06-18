import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/util/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class QuestionCarousel extends StatefulWidget {
  final List questionKeys;

  const QuestionCarousel({
    super.key,
    required this.questionKeys,
  });

  @override
  State<QuestionCarousel> createState() => _QuestionCarouselState();
}

class _QuestionCarouselState extends State<QuestionCarousel> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  final questionBox = Hive.box<Question>('questionBox');
  int currCarouselPage = 0;

  @override
  Widget build(BuildContext context) {
    final carouselLength = widget.questionKeys.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(
              "Term ${currCarouselPage + 1}/$carouselLength",
              style: TextStyle(color: primary[800]),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: controller,
                      onPageChanged: (value) {
                        setState(() {
                          currCarouselPage = value;
                        });
                      },
                      itemCount: carouselLength,
                      itemBuilder: (_, index) {
                        index %= carouselLength;
                        Question question =
                            questionBox.get(widget.questionKeys[index])!;
                        FlipCardController flipCon = FlipCardController();
                        return FlipCard(
                          animationDuration: const Duration(milliseconds: 250),
                          controller: flipCon,
                          rotateSide: RotateSide.bottom,
                          axis: FlipAxis.horizontal,
                          onTapFlipping: true,
                          frontWidget: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: primary[200],
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Center(
                              child: Text(
                                question.term,
                                style: GoogleFonts.jost(
                                  fontSize: 30,
                                  color: primary[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          backWidget: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: primary[200],
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Center(
                              child: Text(
                                question.definition,
                                style: GoogleFonts.jost(
                                  fontSize: 30,
                                  color: primary[800],
                                  fontWeight: FontWeight.w500,
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
                    effect: const ScrollingDotsEffect(
                      activeStrokeWidth: 3,
                      activeDotScale: 1.2,
                      maxVisibleDots: 5,
                      spacing: 10,
                      dotHeight: 12,
                      dotWidth: 12,
                      fixedCenter: true,
                      dotColor: primary,
                      activeDotColor: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
