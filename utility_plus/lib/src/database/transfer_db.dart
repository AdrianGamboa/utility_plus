import 'package:mongo_dart/mongo_dart.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'package:utility_plus/src/utils/global.dart';
import '../models/transfer.dart';

class TransferDB {
  static Future<List<Map<String, dynamic>>> getByUserId() async {
    try {
      final transfers = await MongoDatabase.transferCollection
          .find(where.eq("uid", userFire!.uid.toString()).sortBy("transferDate"))
          .toList();
      return transfers;
    } catch (e) {
      dynamic d;
      print(e);
      d = e;
      return Future.value(d);
    }
  }

  static insert(Transfer transfer) async {
    await MongoDatabase.transferCollection.insertAll([transfer.toMap()]);
  }

  static delete(ObjectId transfer) async {
    await MongoDatabase.transferCollection.remove(where.id(transfer));
  }

  static update(Transfer transfer) async {
    var a = await MongoDatabase.transferCollection.findOne({"_id": transfer.id});
    a["description"] = transfer.description;
    a["amount"] = transfer.amount;
    a["transferDate"] = transfer.transferDate;
    a["cuentaDebita"] = transfer.cuentaDebita;
    a["cuentaAcredita"] = transfer.cuentaAcredita;
    await MongoDatabase.transferCollection.save(a);
  }
}
