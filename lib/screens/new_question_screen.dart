import 'package:flutter/material.dart';

class NewQuestionDialog extends StatelessWidget {
  final void Function(String, String) saveNewQuestion;
  final String quizName;
  final BuildContext context;

  NewQuestionDialog({
    super.key,
    required this.saveNewQuestion,
    required this.quizName,
    required this.context,
  });

  final _questionTermController = TextEditingController();
  final _questionAnswerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void onSave() {
    // Form validate
    if (!_formKey.currentState!.validate()) return;
    
    // Form submit
    saveNewQuestion(_questionTermController.text, _questionAnswerController.text);

    // Form reset
    _questionTermController.clear();
    _questionAnswerController.clear();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'New question created for $quizName!',
        ),
        duration: const Duration(
          milliseconds: 1500,
        ),
        showCloseIcon: true,
        backgroundColor: Colors.green,
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
              Text(
                'Create a new question for $quizName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _questionTermController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Term',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a term';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _questionAnswerController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Definition',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a definition';
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
