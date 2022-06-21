import 'package:firebase_auth/firebase_auth.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../utils/connection.dart';
import 'mongodatabase.dart';
import '../models/note.dart';

class NoteDB {
  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      if (await hasNetwork()) {
        final notes = await MongoDatabase.noteCollection
            .find(where
                .eq('uid', FirebaseAuth.instance.currentUser!.uid)
                .sortBy("pin", descending: true)
                .sortBy("lastDate", descending: true))
            .toList();
        return notes;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Note note) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.noteCollection.insertAll([note.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Note note) async {
    try {
      if (await hasNetwork()) {
        var u = await MongoDatabase.noteCollection.findOne({"_id": note.id});
        u["title"] = note.title;
        u["content"] = note.content;
        u["pin"] = note.pin;
        u["shadeColor"] = note.shadeColor;
        u["mainColor"] = note.mainColor;
        u["image"] = note.image;

        await MongoDatabase.noteCollection.save(u);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(Note note) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.noteCollection.remove(where.id(note.id));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
