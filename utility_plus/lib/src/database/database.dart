import 'package:mongo_dart/mongo_dart.dart';
import '../models/user.dart';
import '../utils/global.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }
   static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final users = await userCollection.find().toList();
      print(users.toString());
      return users;
    } catch (e) {
      dynamic d;
      print(e);
      d=e;
      return Future.value(d);
    }
  }

  static insert(User user) async {
    await userCollection.insertAll([user.toMap()]);
  }

  static update(User user) async {
    var u = await userCollection.findOne({"_id": user.id});
    u["name"] = user.name;
    u["age"] = user.age;
    u["phone"] = user.phone;
    await userCollection.save(u);
  }

  static delete(User user) async {
    await userCollection.remove(where.id(user.id));
  }
}