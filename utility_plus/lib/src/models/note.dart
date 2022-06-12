import 'package:mongo_dart/mongo_dart.dart';

class Note {
  final ObjectId id;
  final String title;
  final String content;
  final bool pin;
  final int shadeColor;
  final int mainColor;
  final String? image;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.pin,
      required this.shadeColor,
      required this.mainColor,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'pin': pin,
      'shadeColor': shadeColor,
      'mainColor': mainColor,
      'image': image,
    };
  }

  Note.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        id = map['_id'],
        content = map['content'],
        pin = map['pin'],
        shadeColor = map['shadeColor'],
        mainColor = map['mainColor'],
        image = map['image'];
}
