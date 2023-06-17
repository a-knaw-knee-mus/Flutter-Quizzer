import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/types/form_types.dart';

class QuizDialog extends StatefulWidget {
  final void Function(String, String, {String? quizId}) saveQuiz;
  final BuildContext context;
  final FormType formType;
  final Quiz? quiz;
  final String? quizId;

  const QuizDialog({
    super.key,
    required this.saveQuiz,
    required this.context,
    required this.formType,
    this.quizId,
    this.quiz,
  });

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  final _quizNameController = TextEditingController();

  final _quizDescController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.quiz != null) {
      _quizNameController.text = widget.quiz!.name;
      _quizDescController.text = widget.quiz!.description;
    }
    super.initState();
  }

  String getDialogTitle() {
    switch (widget.formType) {
      case FormType.create:
        return 'Create a new quiz!';
      case FormType.edit:
        return 'Edit a quiz!';
      default:
        return 'Invalid form type';
    }
  }

  String getSnackbarText() {
    switch (widget.formType) {
      case FormType.create:
        return 'New quiz created!';
      case FormType.edit:
        return 'Quiz edited!';
      default:
        return 'Invalid form type';
    }
  }

  Color getSnackbarColor() {
    switch (widget.formType) {
      case FormType.create:
        return Colors.green;
      case FormType.edit:
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  void onSave() {
    // Form validate
    if (!_formKey.currentState!.validate()) return;

    // Form submit
    widget.saveQuiz(
      _quizNameController.text,
      _quizDescController.text,
      quizId: widget.quizId,
    );

    // Form reset
    _quizNameController.clear();
    _quizDescController.clear();
    Navigator.of(widget.context).pop();
    ScaffoldMessenger.of(widget.context).showSnackBar(
      SnackBar(
        content: Text(
          getSnackbarText(),
        ),
        duration: const Duration(
          milliseconds: 1500,
        ),
        showCloseIcon: true,
        backgroundColor: getSnackbarColor(),
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
                getDialogTitle(),
                style: const TextStyle(
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
                  labelText: 'Quiz Name',
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
                  labelText: 'Quiz Description',
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
