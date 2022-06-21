import 'package:mongo_dart/mongo_dart.dart';

import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/task.dart';
import 'package:utility_plus/src/utils/global.dart';

import '../utils/connection.dart';

class TaskDB {
  static Future<List<Map<String, dynamic>>> getByCategoryId(
      ObjectId category) async {
    try {
      if (await hasNetwork()) {
        final tasks = await MongoDatabase.taskCollection
            .find(where.eq("categoryId", category).sortBy("finished"))
            .toList();
        return tasks;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getByImportance() async {
    try {
      if (await hasNetwork()) {
        final tasks = await MongoDatabase.taskCollection
            .find(where
                .eq("important", true)
                .and(where.eq("userId", userFire!.uid.toString()))
                .sortBy("finished")
                .sortBy('expirationDate'))
            .toList();

        return tasks;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      if (await hasNetwork()) {
        final tasks = await MongoDatabase.taskCollection
            .find(where
                .eq("userId", userFire!.uid.toString())
                .sortBy("finished")
                .sortBy('expirationDate'))
            .toList();

        return tasks;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Task task) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.taskCollection.insertAll([task.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Task task) async {
    try {
      if (await hasNetwork()) {
        var t = await MongoDatabase.taskCollection.findOne({"_id": task.id});

        t["title"] = task.title;
        t["content"] =
            task.content == '' ? 'Tarea sin contenido' : task.content;
        t["expirationDate"] = task.expirationDate == ''
            ? 'Sin fecha de expiración'
            : task.expirationDate;
        t["reminderDate"] =
            task.reminderDate == '' ? 'Sin recordatorio' : task.reminderDate;
        t["important"] = task.important;
        t["finished"] = task.finished;

        t["categoryId"] = task.categoryId;

        await MongoDatabase.taskCollection.save(t);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Task task) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.taskCollection.remove(where.id(task.id));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
