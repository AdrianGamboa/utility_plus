import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/utils/global.dart';
import '../models/user.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

class UserDB {
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final users = await MongoDatabase.userCollection.find().toList();
      return users;
    } catch (e) {
      dynamic d;
      d = e;
      return Future.value(d);
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final users = await MongoDatabase.userCollection
          .findOne(m.where.eq("uid", userFire!.uid.toString()));
      return users;
    } catch (e) {
      dynamic d;
      d = e;
      return Future.value(d);
    }
  }

  static insert(User user) async {
    await MongoDatabase.userCollection.insertAll([user.toMap()]);
  }

  static update(User user) async {
    var u = await MongoDatabase.userCollection.findOne({"_id": user.id});
    u["nombre"] = user.nombre;
    u["primerApellido"] = user.primerApellido;
    u["segundoApellido"] = user.segundoApellido;
    u["email"] = user.email;
    u["uid"] = user.uid;
    await MongoDatabase.userCollection.save(u);
  }

  static delete(User user) async {
    await MongoDatabase.userCollection.remove(where.id(user.id));
  }

  static registerUser(
      nombre, primerApellido, segundoApellido, email, uid) async {
    final user = User(
        id: m.ObjectId(),
        nombre: nombre,
        primerApellido: primerApellido,
        segundoApellido: segundoApellido,
        email: email,
        uid: uid);
    await insert(user);
  }
}
