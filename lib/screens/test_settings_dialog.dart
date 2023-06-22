import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:provider/provider.dart';

enum OrientationType {
  term,
  desc,
}

enum StarredType {
  starredOnly,
  all,
}

class SettingsDialog extends StatefulWidget {
  final bool sorting;
  final bool termStart;
  final bool starredOnly;
  final VoidCallback restartTest;
  final void Function(bool) toggleSorting;
  final void Function(bool) setTermStart;
  final void Function(bool) setStarredOnly;

  const SettingsDialog({
    super.key,
    required this.sorting,
    required this.termStart,
    required this.starredOnly,
    required this.restartTest,
    required this.toggleSorting,
    required this.setTermStart,
    required this.setStarredOnly,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late bool _sorting, _termStart, _starredOnly;

  @override
  void initState() {
    _sorting = widget.sorting;
    _termStart = widget.termStart;
    _starredOnly = widget.starredOnly;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    return Container(
      color: themeColor[400],
      height: 450,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Options',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(
                thickness: 2,
                color: themeColor[700],
                endIndent: 30,
                indent: 30,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Track successful/unsuccessful terms:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Switch(
                  value: _sorting,
                  onChanged: (bool val) {
                    widget.toggleSorting(val);
                    setState(() => _sorting = !_sorting);
                  },
                  activeColor: themeColor[800],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Starting Side:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SegmentedButton(
                  segments: const <ButtonSegment<OrientationType>>[
                    ButtonSegment<OrientationType>(
                      value: OrientationType.term,
                      label: Text('Term'),
                    ),
                    ButtonSegment<OrientationType>(
                      value: OrientationType.desc,
                      label: Text('Definition'),
                    ),
                  ],
                  selected: <OrientationType>{
                    _termStart ? OrientationType.term : OrientationType.desc
                  },
                  onSelectionChanged: (Set<OrientationType> newVal) {
                    bool termStart = newVal.first == OrientationType.term;
                    widget.setTermStart(termStart);
                    setState(() {
                      _termStart = termStart;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Study using:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SegmentedButton(
                  segments: const <ButtonSegment<StarredType>>[
                    ButtonSegment<StarredType>(
                      value: StarredType.all,
                      label: Text('All'),
                    ),
                    ButtonSegment<StarredType>(
                      value: StarredType.starredOnly,
                      label: Text('Starred Only'),
                    ),
                  ],
                  selected: <StarredType>{
                    _starredOnly ? StarredType.starredOnly : StarredType.all
                  },
                  onSelectionChanged: (Set<StarredType> newVal) {
                    bool starredOnly = newVal.first == StarredType.starredOnly;
                    widget.setStarredOnly(starredOnly);
                    setState(() {
                      _starredOnly = starredOnly;
                    });
                  },
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SHUFFLE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.shuffle_rounded),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Restart Flashcards',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
