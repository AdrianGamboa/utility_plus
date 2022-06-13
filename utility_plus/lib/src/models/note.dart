import 'package:mongo_dart/mongo_dart.dart';

class Note {
  final ObjectId id;
  final String uid;
  final String title;
  final String content;
  final bool pin;
  final int shadeColor;
  final int mainColor;
  final DateTime lastDate;
  final String? image;

  Note(
      {required this.id,
      required this.uid,
      required this.title,
      required this.content,
      required this.pin,
      required this.shadeColor,
      required this.mainColor,
      required this.lastDate,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'pin': pin,
      'shadeColor': shadeColor,
      'mainColor': mainColor,
      'lastDate': lastDate,
      'image': image,
    };
  }

  Note.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        id = map['_id'],
        uid = map['uid'],
        content = map['content'],
        pin = map['pin'],
        shadeColor = map['shadeColor'],
        mainColor = map['mainColor'],
        lastDate = map['lastDate'],
        image = map['image'];
}
