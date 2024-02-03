import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizzer/main.dart';
import 'package:flutter_quizzer/schema/question.dart';
import 'package:flutter_quizzer/schema/quiz.dart';
import 'package:flutter_quizzer/util/color_types.dart';
import 'package:flutter_quizzer/util/form_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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

  AlertDialog getImportQuizHelpDialog() {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select a txt file to import a quiz with its questions. \n\nA study set can be exported from Quizlet with 'Between term and definition' set to '--' and 'Between rows' set to 'New line'. Copy the text and save it to a txt file on your device along with the quiz name and description at the top.\n\nThe file should be in the format:\n",
            textAlign: TextAlign.start,
            style: GoogleFonts.robotoMono(fontSize: 14),
          ),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '''<Quiz Name>--<Quiz Desc>\n<Term 1>--<Definition 1>\n<Term 2>--<Definition 2>\n<Term 3>--<Definition 3>\n...''',
                style: GoogleFonts.robotoMono(fontSize: 14),
              ))
        ],
      ),
    );
  }

  void importQuiz() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['txt']);
    if (result == null) return;

    try {
      String filePath = result.files.single.path!;
      File file = File(filePath);
      String contents = await file.readAsString();
      List<String> lines = contents.split('\n');

      // handle quiz name and description seperately
      String quizId = const Uuid().v1();
      try {
        List<String> parts = lines[0].split('--');
        String quizName = parts[0], quizDesc = parts[1];
        final quizBox = Hive.box<Quiz>('quizBox');
        setState(() {
          quizBox.put(
            quizId,
            Quiz(
              name: quizName,
              description: quizDesc,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        });
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid Quiz name/description.',
                style: GoogleFonts.jost(),
              ),
              duration: const Duration(
                milliseconds: 1500,
              ),
              showCloseIcon: true,
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      lines.removeAt(0);
      final questionBox = Hive.box<Question>('questionBox');
      Duration timeStep = const Duration(milliseconds: 1); // add time offset to keep order
      DateTime currentDateTime = DateTime.now();
      for (String line in lines) {
        try {
          List<String> parts = line.split('--');
          String term = parts[0], definition = parts[1];
          currentDateTime = currentDateTime.add(timeStep);
          setState(() {
            questionBox.put(
              const Uuid().v1(),
              Question(
                term: term,
                definition: definition,
                quizId: quizId,
                createdAt: currentDateTime,
                updatedAt: currentDateTime,
                isStarred: false,
              ),
            );
          });
        } catch (e) {
          continue;
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Quiz imported.',
              style: GoogleFonts.jost(),
            ),
            duration: const Duration(
              milliseconds: 1500,
            ),
            showCloseIcon: true,
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error reading file.',
              style: GoogleFonts.jost(),
            ),
            duration: const Duration(
              milliseconds: 1500,
            ),
            showCloseIcon: true,
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
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
    MaterialColor themeColor =
        context.watch<ColorProvider>().color.getColorSwatch();

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      backgroundColor: themeColor[200],
      content: Form(
        key: _formKey,
        child: SizedBox(
          height: 360,
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
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
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
                    child: Text(
                      'Save',
                      style: GoogleFonts.jost(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.jost(),
                    ),
                  ),
                ],
              ),
              const Row(children: [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("OR"),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ]),
              ElevatedButton(
                onPressed: importQuiz,
                style: ElevatedButton.styleFrom(
                  elevation: 12.0,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Import Quiz from Storage',
                      style: GoogleFonts.jost(),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return getImportQuizHelpDialog();
                            },
                          );
                        },
                        icon: const Icon(Icons.info_outline_rounded))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
