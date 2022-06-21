import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/utils/global.dart';
import '../models/user.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

import '../utils/connection.dart';

class UserDB {
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      if (await hasNetwork()) {
        final users = await MongoDatabase.userCollection.find().toList();
        return users;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      if (await hasNetwork()) {
        final users = await MongoDatabase.userCollection
            .findOne(m.where.eq("uid", userFire!.uid.toString()));
        return users;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<Map<String, dynamic>>.error(e);
    }
  }

  static insert(User user) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.userCollection.insertAll([user.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(User user) async {
    try {
      if (await hasNetwork()) {
        var u = await MongoDatabase.userCollection.findOne({"_id": user.id});
        u["nombre"] = user.nombre;
        u["primerApellido"] = user.primerApellido;
        u["segundoApellido"] = user.segundoApellido;
        u["email"] = user.email;
        u["uid"] = user.uid;
        await MongoDatabase.userCollection.save(u);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(User user) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.userCollection.remove(where.id(user.id));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static registerUser(
      nombre, primerApellido, segundoApellido, email, uid) async {
    try {
      if (await hasNetwork()) {
        final user = User(
            id: m.ObjectId(),
            nombre: nombre,
            primerApellido: primerApellido,
            segundoApellido: segundoApellido,
            email: email,
            uid: uid);
        await insert(user);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
