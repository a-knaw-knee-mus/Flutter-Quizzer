import 'package:flutter/material.dart';

class NewQuizDialog extends StatelessWidget {
  final void Function(String, String) saveNewQuiz;
  final BuildContext context;

  NewQuizDialog({super.key, required this.saveNewQuiz, required this.context});

  final _quizNameController = TextEditingController();
  final _quizDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void onSave() {
    // Form validate
    if (!_formKey.currentState!.validate()) return;

    // Form submit
    saveNewQuiz(_quizNameController.text, _quizDescController.text);

    // Form reset
    _quizNameController.clear();
    _quizDescController.clear();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'New quiz created!',
        ),
        duration: Duration(
          milliseconds: 1500,
        ),
        showCloseIcon: true,
        backgroundColor: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: SizedBox(
          height: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create a new quiz',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _quizNameController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Quiz Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quiz name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quizDescController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Quiz Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quiz description';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
