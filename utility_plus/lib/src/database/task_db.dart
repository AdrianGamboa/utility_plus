import 'package:mongo_dart/mongo_dart.dart';

import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/task.dart';
import 'package:utility_plus/src/utils/global.dart';

class TaskDB {
  static Future<List<Map<String, dynamic>>> getByCategoryId(
      ObjectId category) async {
    try {
      final tasks = await MongoDatabase.taskCollection
          .find(where.eq("categoryId", category).sortBy("finished"))
          .toList();
      return tasks;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static Future<List<Map<String, dynamic>>> getByImportance() async {
    try {
      final tasks = await MongoDatabase.taskCollection
          .find(where
              .eq("important", true)
              .and(where.eq("userId", userFire!.uid.toString()))
              .sortBy("finished")
              .sortBy('expirationDate'))
          .toList();

      return tasks;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      final tasks = await MongoDatabase.taskCollection
          .find(where
              .eq("userId", userFire!.uid.toString())
              .sortBy("finished")
              .sortBy('expirationDate'))
          .toList();

      return tasks;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static insert(Task task) async {
    await MongoDatabase.taskCollection.insertAll([task.toMap()]);
  }

  static update(Task task) async {
    var t = await MongoDatabase.taskCollection.findOne({"_id": task.id});

    t["title"] = task.title;
    t["content"] = task.content == '' ? 'Tarea sin contenido' : task.content;
    t["expirationDate"] = task.expirationDate == ''
        ? 'Sin fecha de expiración'
        : task.expirationDate;
    t["reminderDate"] =
        task.reminderDate == '' ? 'Sin recordatorio' : task.reminderDate;
    t["important"] = task.important;
    t["finished"] = task.finished;

    t["categoryId"] = task.categoryId;

    await MongoDatabase.taskCollection.save(t);
  }

  static delete(Task task) async {
    await MongoDatabase.taskCollection.remove(where.id(task.id));
  }
}
