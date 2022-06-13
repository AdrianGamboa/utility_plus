import 'package:firebase_auth/firebase_auth.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'mongodatabase.dart';
import '../models/note.dart';

class NoteDB {
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final notes = await MongoDatabase.noteCollection
          .find(where
              .eq('uid', FirebaseAuth.instance.currentUser!.uid)
              .sortBy("pin", descending: true))
          .toList();
      //print(notes.toString());
      return notes;
    } catch (e) {
      dynamic d;
      //print(e);
      d = e;
      return Future.value(d);
    }
  }

  static insert(Note note) async {
    await MongoDatabase.noteCollection.insertAll([note.toMap()]);
  }

  static update(Note note) async {
    var u = await MongoDatabase.noteCollection.findOne({"_id": note.id});
    u["title"] = note.title;
    u["content"] = note.content;
    u["pin"] = note.pin;
    u["shadeColor"] = note.shadeColor;
    u["mainColor"] = note.mainColor;
    u["image"] = note.image;

    await MongoDatabase.noteCollection.save(u);
  }

  static delete(Note note) async {
    await MongoDatabase.noteCollection.remove(where.id(note.id));
  }
}
