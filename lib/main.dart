import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/preference.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/quizzes_screen.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/util/sort_question.dart';
import 'package:flutter_quizzer/util/sort_quiz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

class ColorProvider extends ChangeNotifier {
  ColorType _color = ColorType.purple;

  ColorType get color => _color;

  set color(ColorType newColor) {
    _color = newColor;
    notifyListeners();
  }
}

class AlignProvider extends ChangeNotifier {
  AlignType _alignType = AlignType.left;

  AlignType get alignType => _alignType;

  set alignType(AlignType newAlignType) {
    _alignType = newAlignType;
    notifyListeners();
  }
}

class QuestionSortTypeProvider extends ChangeNotifier {
  QuestionSortType _questionSortType = QuestionSortType.termAsc;

  QuestionSortType get questionSortType => _questionSortType;

  set questionSortType(QuestionSortType newQuestionSortType) {
    _questionSortType = newQuestionSortType;
    notifyListeners();
  }
}

class QuizSortTypeProvider extends ChangeNotifier {
  QuizSortType _quizSortType = QuizSortType.nameAsc;

  QuizSortType get quizSortType => _quizSortType;

  set quizSortType(QuizSortType newQuizSortType) {
    _quizSortType = newQuizSortType;
    notifyListeners();
  }
}

void main() async {
  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(QuizAdapter());
  await Hive.openBox<Quiz>('quizBox');
  Hive.registerAdapter(QuestionAdapter());
  await Hive.openBox<Question>('questionBox');
  Hive.registerAdapter(PreferenceAdapter());
  await Hive.openBox<Preference>('prefBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ColorProvider>(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider<AlignProvider>(
          create: (context) => AlignProvider(),
        ),
        ChangeNotifierProvider<QuizSortTypeProvider>(
          create: (context) => QuizSortTypeProvider(),
        ),
        ChangeNotifierProvider<QuestionSortTypeProvider>(
          create: (context) => QuestionSortTypeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    final prefBox = Hive.box<Preference>('prefBox');
    Preference userTheme = prefBox.get(
      'colorTheme',
      defaultValue: Preference(value: 'purple'),
    )!;
    Preference alignType = prefBox.get(
      'alignTheme',
      defaultValue: Preference(value: 'left'),
    )!;
    Preference quizSortType = prefBox.get(
      'quizSortType',
      defaultValue: Preference(value: 'nameAsc'),
    )!;
    Preference questionSortType = prefBox.get(
      'questionSortType',
      defaultValue: Preference(value: 'termAsc'),
    )!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlignProvider>(context, listen: false).alignType =
          AlignTypeExtension.getAlignTypeFromString(alignType.value);
      Provider.of<ColorProvider>(context, listen: false).color =
          ColorTypeExtension.getColorTypeFromString(userTheme.value);
      Provider.of<QuizSortTypeProvider>(context, listen: false).quizSortType =
          QuizSortExtension.getQuizSortTypeFromString(quizSortType.value);
      Provider.of<QuestionSortTypeProvider>(context, listen: false).questionSortType =
          QuestionSortExtension.getQuestionSortTypeFromString(questionSortType.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizWiz',
      home: UpgradeAlert(child: const MyPage()),
      theme: ThemeData(
        primarySwatch: context.watch<ColorProvider>().color.getColorSwatch(),
        textTheme: GoogleFonts.jostTextTheme(),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QuizzesScreen(),
    );
  }
}
