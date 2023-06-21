import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Column(
          children: [
            Text(
              'Test Screen',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Text(
              'Hello',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => 'Settings pressed',
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Container(),
    );
  }
}
