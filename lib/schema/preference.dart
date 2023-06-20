import 'package:hive/hive.dart';

part 'preference.g.dart';

// Key will be the preference name
@HiveType(typeId: 2)
class Preference {
  Preference({
    required this.value,
  });

  @HiveField(0)
  String value;
}
