import 'package:hive/hive.dart';

part 'quiz.g.dart';

// Key will be the quizId
@HiveType(typeId: 0)
class Quiz {
  Quiz({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;
}
