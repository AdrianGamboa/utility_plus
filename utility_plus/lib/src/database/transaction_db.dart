import 'package:mongo_dart/mongo_dart.dart';

import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/transaction.dart';
import 'package:utility_plus/src/utils/global.dart';

import '../utils/connection.dart';

class TransactionDB {
  static Future<List<Map<String, dynamic>>> getByCategoryId(
      ObjectId category) async {
    try {
      if (await hasNetwork()) {
        final tasks = await MongoDatabase.taskCollection
            .find(where.eq("categoryId", category).sortBy("finished"))
            .toList();
        return tasks;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getByImportance() async {
    try {
      if (await hasNetwork()) {
        final tasks = await MongoDatabase.taskCollection
            .find(where
                .eq("important", true)
                .and(where.eq("userId", userFire!.uid.toString()))
                .sortBy("finished")
                .sortBy('expirationDate'))
            .toList();

        return tasks;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getByType(String type) async {
    try {
      if (await hasNetwork()) {
        final transactions = await MongoDatabase.transactionCollection
            .find(where
                .eq("type", type)
                .and(where.eq("uid", userFire!.uid.toString()))
                .sortBy("transactionDate"))
            .toList();

        return transactions;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getByTypeAndAccount(
      String type, accountId) async {
    try {
      if (await hasNetwork()) {
        final transactions = await MongoDatabase.transactionCollection
            .find(where
                .eq("type", type)
                .and(where
                    .eq("uid", userFire!.uid.toString())
                    .and(where.eq("accountId", accountId)))
                .sortBy("transactionDate"))
            .toList();
        return transactions;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Transaction transaction) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.transactionCollection
            .insertAll([transaction.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Transaction transaction) async {
    try {
      if (await hasNetwork()) {
        var t = await MongoDatabase.transactionCollection
            .findOne({"_id": transaction.id});

        t["title"] = transaction.title;
        t["description"] = transaction.description;
        t["amount"] = transaction.amount;
        t["transactionDate"] = transaction.transactionDate;
        t["accountId"] = transaction.accountId;

        await MongoDatabase.transactionCollection.save(t);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(ObjectId transaction) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.transactionCollection.remove(where.id(transaction));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static deleteByAccountId(ObjectId accountId) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.transactionCollection
            .remove(where.eq('accountId', accountId));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
