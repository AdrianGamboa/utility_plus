import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/utils/global.dart';

class Task {
  final ObjectId id;
  String title;
  String? content;
  String? expirationDate;
  String? reminderDate;
  bool important;
  bool? finished;
  ObjectId categoryId;
  String? userId;

  Task(
      {required this.id,
      required this.title,
      this.content,
      this.expirationDate,
      this.reminderDate,
      required this.important,
      this.finished,
      required this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content == '' ? 'Tarea sin contenido' : content,
      'expirationDate':
          expirationDate == '' ? 'Sin fecha de expiración' : expirationDate,
      'reminderDate': reminderDate == '' ? 'Sin recordatorio' : reminderDate,
      'important': important,
      'finished': false,
      'userId': userFire!.uid.toString(),
      'categoryId': categoryId
    };
  }

  Task.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        content = map['content'],
        expirationDate = map['expirationDate'],
        reminderDate = map['reminderDate'],
        important = map['important'],
        finished = map['finished'],
        categoryId = map['categoryId'],
        id = map['_id'];
}
