import 'package:hive/hive.dart';

part 'bmi_record.g.dart';

@HiveType(typeId: 0)
class BMIRecord extends HiveObject {
  @HiveField(0)
  late DateTime dateTime;

  @HiveField(1)
  late double weight;

  @HiveField(2)
  late double height;

  @HiveField(3)
  late double bmi;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late String gender;

  @HiveField(6)
  late int age;

  BMIRecord({
    required this.dateTime,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.gender,
    required this.age,
  });

  String get formattedDate {
    final now = DateTime.now();
    final date = dateTime;

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String get formattedTime {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
