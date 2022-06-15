import 'package:mongo_dart/mongo_dart.dart';

class Account {
  final ObjectId id;
  final String name;
  final int amount;
  final int icon;
  final int color;
  final String uid;

  Account(
      {required this.id,
      required this.name,
      required this.amount,
      required this.icon,
      required this.color,
      required this.uid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'amount': amount,
      'icon': icon,
      'color': color,
      'uid': uid
    };
  }

  Account.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        amount = map['amount'],
        icon = map['icon'],
        color = map['color'],
        uid = map['uid'];
}
