import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/category.dart';
import 'package:utility_plus/src/utils/global.dart';

class CategoryDB {
  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      final categories = await MongoDatabase.categoryCollection
          .find(where.eq("userId", userFire!.uid.toString()).sortBy("created"))
          .toList();
      return categories;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static Future<Map<String, dynamic>?> getByName(String name) async {
    final categories = await MongoDatabase.categoryCollection
        .findOne({"name": name, "userId": userFire!.uid.toString()});
    return categories;
  }

  static insert(Category category) async {
    await MongoDatabase.categoryCollection.insertAll([category.toMap()]);
  }

  static delete(Category category) async {
    await MongoDatabase.categoryCollection.remove(where.id(category.id));
    await MongoDatabase.taskCollection
        .remove(where.eq('categoryId', category.id));
  }
}
