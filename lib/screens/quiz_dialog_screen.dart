import 'package:flutter/material.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizDialog extends StatefulWidget {
  final BuildContext context;
  final void Function(String, String) saveNewQuiz;
  final void Function(String, String, String, DateTime) editQuiz;
  final FormType formType;
  // for edited quizzes
  final Quiz? quiz;
  final String? quizId;

  const QuizDialog({
    super.key,
    required this.context,
    required this.formType,
    required this.saveNewQuiz,
    required this.editQuiz,
    // for edited quizzes
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
    switch (widget.formType) {
      case FormType.create:
        {
          widget.saveNewQuiz(
            _quizNameController.text,
            _quizDescController.text,
          );
          break;
        }
      case FormType.edit:
        {
          widget.editQuiz(
            _quizNameController.text,
            _quizDescController.text,
            widget.quizId!,
            widget.quiz!.createdAt,
          );
          break;
        }
      default:
        {
          throw 'Invalid form type';
        }
    }

    // Form reset
    _quizNameController.clear();
    _quizDescController.clear();
    Navigator.of(widget.context).pop();
    ScaffoldMessenger.of(widget.context).showSnackBar(
      SnackBar(
        content: Text(
          getSnackbarText(),
          style: GoogleFonts.jost(),
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
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _quizNameController,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                style: GoogleFonts.jost(),
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
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 3,
                style: GoogleFonts.jost(),
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
                      textStyle: GoogleFonts.jost(
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.jost(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: GoogleFonts.jost(
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.jost(),
                    ),
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
