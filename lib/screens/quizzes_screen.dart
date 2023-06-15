import 'package:flutter/material.dart';
import 'package:flutter_quizzer/screens/new_quiz_screen.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final quizSets = ['animals', 'names', 'science', 'planing stuf', 'testing 2'];
  final _controller = TextEditingController();

  void showQuizDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return NewQuizDialog(
          controller: _controller,
          onSave: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Quizzes'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('New Quiz'),
          icon: const Icon(Icons.add),
          onPressed: showQuizDialog,
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: ListView.builder(
          itemCount: quizSets.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  print('click box $index');
                },
                child: Container(
                  color: Colors.amber,
                  height: 50,
                  child: Text(quizSets[index]),
                ),
              ),
            );
          },
        ));
  }
}
