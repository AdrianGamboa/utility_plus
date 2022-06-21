import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/account.dart';
import 'package:utility_plus/src/utils/global.dart';

import '../utils/connection.dart';

class AccountDB {
  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      if (await hasNetwork()) {
        final accounts = await MongoDatabase.accountCollection
            .find(where.eq("uid", userFire!.uid.toString()).sortBy("amount"))
            .toList();
        return accounts;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Account account) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.accountCollection.insertAll([account.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(ObjectId account) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.accountCollection.remove(where.id(account));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Account account) async {
    try {
      if (await hasNetwork()) {
        var a =
            await MongoDatabase.accountCollection.findOne({"_id": account.id});
        a["name"] = account.name;
        a["amount"] = account.amount;
        a["icon"] = account.icon;
        a["color"] = account.color;

        await MongoDatabase.accountCollection.save(a);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static updateAmount(ObjectId accountId, int amount_) async {
    try {
      if (await hasNetwork()) {
        var a =
            await MongoDatabase.accountCollection.findOne({"_id": accountId});

        a["amount"] = a["amount"] + amount_;

        await MongoDatabase.accountCollection.save(a);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
