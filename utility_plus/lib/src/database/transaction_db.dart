import 'package:mongo_dart/mongo_dart.dart';

import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/transaction.dart';
import 'package:utility_plus/src/utils/global.dart';

class TransactionDB {
  static Future<List<Map<String, dynamic>>> getByCategoryId(
      ObjectId category) async {
    try {
      final tasks = await MongoDatabase.taskCollection
          .find(where.eq("categoryId", category).sortBy("finished"))
          .toList();
      return tasks;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static Future<List<Map<String, dynamic>>> getByImportance() async {
    try {
      final tasks = await MongoDatabase.taskCollection
          .find(where
              .eq("important", true)
              .and(where.eq("userId", userFire!.uid.toString()))
              .sortBy("finished")
              .sortBy('expirationDate'))
          .toList();

      return tasks;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static Future<List<Map<String, dynamic>>> getByType(String type) async {
    try {
      final transactions = await MongoDatabase.transactionCollection
          .find(where
              .eq("type", type)
              .and(where.eq("uid", userFire!.uid.toString()))
              .sortBy("transactionDate"))
          .toList();

      return transactions;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static Future<List<Map<String, dynamic>>> getByTypeAndAccount(
      String type, accountId) async {
    try {
      final transactions = await MongoDatabase.transactionCollection
          .find(where
              .eq("type", type)
              .and(where
                  .eq("uid", userFire!.uid.toString())
                  .and(where.eq("accountId", accountId)))
              .sortBy("transactionDate"))
          .toList();
      return transactions;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static insert(Transaction transaction) async {
    await MongoDatabase.transactionCollection.insertAll([transaction.toMap()]);
  }

  static update(Transaction transaction) async {
    var t = await MongoDatabase.transactionCollection
        .findOne({"_id": transaction.id});

    t["title"] = transaction.title;
    t["description"] = transaction.description;
    t["amount"] = transaction.amount;
    t["transactionDate"] = transaction.transactionDate;
    t["accountId"] = transaction.accountId;

    await MongoDatabase.transactionCollection.save(t);
  }

  static delete(ObjectId transaction) async {
    await MongoDatabase.transactionCollection.remove(where.id(transaction));
  }

  static deleteByAccountId(ObjectId accountId) async {
    await MongoDatabase.transactionCollection
        .remove(where.eq('accountId', accountId));
  }
}
