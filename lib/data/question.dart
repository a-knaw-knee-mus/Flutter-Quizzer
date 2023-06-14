import 'package:hive/hive.dart';

part 'question.g.dart';

// Key will be the questionId
@HiveType(typeId: 1)
class Question {
  Question({
    required this.term,
    required this.definition,
    required this.quizId,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  String term;

  @HiveField(1)
  bool definition;

  @HiveField(2)
  String quizId;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;
}
