import 'package:flutter/material.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:flutter_quizzer/schema/question.dart';

class QuestionDialog extends StatefulWidget {
  final BuildContext context;
  final void Function(String, String) saveNewQuestion;
  final void Function(String, String, String, DateTime) editQuestion;
  final String quizName;
  final FormType formType;
  // for edited questions
  final Question? question;
  final String? questionId;

  const QuestionDialog({
    super.key,
    required this.quizName,
    required this.context,
    required this.formType,
    required this.saveNewQuestion,
    required this.editQuestion,
    // for edited questions
    this.question,
    this.questionId,
  });

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final _questionTermController = TextEditingController();
  final _questionDefinitionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.question != null) {
      _questionTermController.text = widget.question!.term;
      _questionDefinitionController.text = widget.question!.definition;
    }
    super.initState();
  }

  String getDialogTitle() {
    switch (widget.formType) {
      case FormType.create:
        return 'Create a new question';
      case FormType.edit:
        return 'Edit a question';
      default:
        return 'Invalid form type';
    }
  }

  String getSnackbarText() {
    switch (widget.formType) {
      case FormType.create:
        return 'New question created for ${widget.quizName}!';
      case FormType.edit:
        return 'Question Edited!';
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
    switch (widget.formType) {
      case FormType.create:
        {
          widget.saveNewQuestion(
            _questionTermController.text,
            _questionDefinitionController.text,
          );
          break;
        }
      case FormType.edit:
        {
          widget.editQuestion(
            _questionTermController.text,
            _questionDefinitionController.text,
            widget.questionId!,
            widget.question!.createdAt,
          );
          break;
        }
      default:
        {
          throw 'Invalid form type';
        }
    }

    // Form reset
    _questionTermController.clear();
    _questionDefinitionController.clear();
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
                controller: _questionTermController,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Term',
                  labelText: 'Term',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a term';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _questionDefinitionController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Definition',
                  labelText: 'Definition',
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
