import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/category.dart';
import 'package:utility_plus/src/utils/global.dart';
import '../utils/connection.dart';

class CategoryDB {
  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      if (await hasNetwork()) {
        final categories = await MongoDatabase.categoryCollection
            .find(
                where.eq("userId", userFire!.uid.toString()).sortBy("created"))
            .toList();
        return categories;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<Map<String, dynamic>?> getByName(String name) async {
    try {
      if (await hasNetwork()) {
        final categories = await MongoDatabase.categoryCollection
            .findOne({"name": name, "userId": userFire!.uid.toString()});
        return categories;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<Map<String, dynamic>>.error(e);
    }
  }

  static insert(Category category) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.categoryCollection.insertAll([category.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Category category) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.categoryCollection.remove(where.id(category.id));
        await MongoDatabase.taskCollection
            .remove(where.eq('categoryId', category.id));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
