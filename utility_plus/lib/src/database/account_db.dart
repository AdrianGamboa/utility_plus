import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/models/account.dart';
import 'package:utility_plus/src/utils/global.dart';

class AccountDB {
  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      final accounts = await MongoDatabase.accountCollection
          .find(where.eq("uid", userFire!.uid.toString()).sortBy("amount"))
          .toList();
      return accounts;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static insert(Account account) async {
    await MongoDatabase.accountCollection.insertAll([account.toMap()]);
  }

  static delete(ObjectId account) async {
    await MongoDatabase.accountCollection.remove(where.id(account));
  }

  static update(Account account) async {
    var a = await MongoDatabase.accountCollection.findOne({"_id": account.id});
    a["name"] = account.name;
    a["amount"] = account.amount;
    a["icon"] = account.icon;
    a["color"] = account.color;

    await MongoDatabase.accountCollection.save(a);
  }

  static updateAmount(ObjectId accountId, int amount_) async {
    var a = await MongoDatabase.accountCollection.findOne({"_id": accountId});

    a["amount"] = a["amount"] + amount_;

    await MongoDatabase.accountCollection.save(a);
  }
}
