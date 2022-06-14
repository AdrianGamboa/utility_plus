import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/utils/global.dart';

class Category {
  final ObjectId id;
  final String name;
  String? userId;
  final DateTime? created;

  Category({required this.id, required this.name, this.created});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'userId': userFire!.uid.toString(),
      'created': DateTime.now()
    };
  }

  Category.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        userId = map['userId'],
        created = map['created'],
        id = map['_id'];
}
