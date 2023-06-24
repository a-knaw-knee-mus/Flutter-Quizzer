import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/preference.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/quizzes_screen.dart';
import 'package:flutter_quizzer/util/align_types.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlignProvider>(context, listen: false).alignType =
          AlignTypeExtension.getAlignTypeFromString(alignType.value);
      Provider.of<ColorProvider>(context, listen: false).color =
          ColorTypeExtension.getColorTypeFromString(userTheme.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizWiz',
      home: const MyPage(),
      theme: ThemeData(
        primarySwatch: context.watch<ColorProvider>().color.getColorSwatch(),
        textTheme: GoogleFonts.jostTextTheme(),
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
