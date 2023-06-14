import 'package:flutter/material.dart';

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final quizSets = ['animals', 'names', 'science', 'planing stuf', 'testing 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Quizzes'),
        ),
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
                ));
          },
        ));
  }
}
