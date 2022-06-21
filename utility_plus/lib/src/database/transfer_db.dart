import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/utils/global.dart';
import '../models/transfer.dart';
import '../utils/connection.dart';

class TransferDB {
  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      if (await hasNetwork()) {
        final transfers = await MongoDatabase.transferCollection
            .find(where
                .eq("uid", userFire!.uid.toString())
                .sortBy("transferDate"))
            .toList();
        return transfers;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future<List<Map<String, dynamic>>>.error(e);
    }
  }

  static insert(Transfer transfer) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.transferCollection.insertAll([transfer.toMap()]);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static delete(ObjectId transfer) async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.transferCollection.remove(where.id(transfer));
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  static update(Transfer transfer) async {
    try {
      if (await hasNetwork()) {
        var a = await MongoDatabase.transferCollection
            .findOne({"_id": transfer.id});
        a["description"] = transfer.description;
        a["amount"] = transfer.amount;
        a["transferDate"] = transfer.transferDate;
        a["cuentaDebita"] = transfer.cuentaDebita;
        a["cuentaAcredita"] = transfer.cuentaAcredita;
        await MongoDatabase.transferCollection.save(a);
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
