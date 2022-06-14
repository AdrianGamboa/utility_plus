// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:mongo_dart/mongo_dart.dart';
import '../utils/global.dart';

class MongoDatabase {
  static var db,
      userCollection,
      noteCollection,
      categoryCollection,
      taskCollection;

  static connect() async {
    db = await Db.create(mongoConnUrl);
    await db.open();
    userCollection = db.collection('usuarios');
    noteCollection = db.collection("notes");
    taskCollection = db.collection('tareas');
    categoryCollection = db.collection('categorias');
  }
}
