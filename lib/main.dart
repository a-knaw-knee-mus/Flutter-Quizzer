import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/screens/profile_screen.dart';
import 'package:flutter_quizzer/screens/quizzes_screen.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class ColorProvider extends ChangeNotifier {
  ColorType _color = ColorType.blue;

  ColorType get color => _color;

  set color(ColorType newColor) {
    _color = newColor;
    notifyListeners();
  }

  void init(ColorType newColor) {
    if (_color != newColor) {
      _color = newColor;
      notifyListeners();
    }
  }
}

void main() async {
  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(QuizAdapter());
  await Hive.openBox<Quiz>('quizBox');
  Hive.registerAdapter(QuestionAdapter());
  await Hive.openBox<Question>('questionBox');
  runApp(ChangeNotifierProvider(
    create: (context) => ColorProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ColorProvider>(context, listen: false)
          .init(ColorType.green);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation with Arguments',
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
  List<Widget> pageList = [
    const QuizzesScreen(),
    const ProfileScreen(),
  ];
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_currentPage],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentPage,
        onTap: (i) => setState(() => _currentPage = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: Text(
              'Your Quizzes',
              style: GoogleFonts.jost(),
            ),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: Text(
              'Settings',
              style: GoogleFonts.jost(),
            ),
          ),
        ],
      ),
    );
  }
}
