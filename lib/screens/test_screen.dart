import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_quizzer/widgets/test/test_settings_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool sorting = true;
  bool termStart = true;
  bool starredOnly = false;

  void toggleSorting(bool val) {
    setState(() {
      sorting = val;
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
    });
  }

  void restartTest() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: const Icon(Icons.close_rounded),
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
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) {
                  return SettingsDialog(
                    sorting: sorting,
                    starredOnly: starredOnly,
                    termStart: termStart,
                    restartTest: restartTest,
                    toggleSorting: toggleSorting,
                    setTermStart: setTermStart,
                    setStarredOnly: setStarredOnly,
                  );
                },
                enableDrag: true,
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Container(),
    );
  }
}
