import 'package:flutter/material.dart';

class NewQuizDialog extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback onSave;

  const NewQuizDialog({super.key, required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: onSave,
                  child: const Text('Save'),
                ),
                MaterialButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
