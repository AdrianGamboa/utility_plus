import 'package:mongo_dart/mongo_dart.dart';

class Transfer {
  final ObjectId? id;
  final int amount;
  final String description;
  final String? transferDate;
  final ObjectId cuentaDebita;
  final ObjectId cuentaAcredita;
  final String? uid;

  Transfer(
      {this.id,
      required this.amount,
      required this.description,
      required this.transferDate,
      required this.cuentaDebita,
      required this.cuentaAcredita,
      this.uid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'amount': amount,
      'description': description,
      'transferDate': transferDate,
      'cuentaDebita': cuentaDebita,
      'cuentaAcredita': cuentaAcredita,
      'uid': uid
    };
  }

  Transfer.fromMap(Map<String, dynamic> map)
      : description = map['description'],
        id = map['_id'],
        amount = map['amount'],
        transferDate = map['transferDate'],
        cuentaDebita = map['cuentaDebita'],
        cuentaAcredita = map['cuentaAcredita'],
        uid = map['uid'];
}
