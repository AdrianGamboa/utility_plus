import 'package:mongo_dart/mongo_dart.dart';

class Transaction {
  final ObjectId id;
  final String title;
  final String description;
  final int amount;
  final String transactionDate;

  final String type;
  final ObjectId accountId;
  final String uid;

  Transaction(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      required this.transactionDate,
      required this.type,
      required this.accountId,
      required this.uid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'transactionDate': transactionDate,
      'type': type,
      'accountId': accountId,
      'uid': uid
    };
  }

  Transaction.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        title = map['title'],
        description = map['description'],
        amount = map['amount'],
        transactionDate = map['transactionDate'],
        type = map['type'],
        accountId = map['accountId'],
        uid = map['uid'];
}
