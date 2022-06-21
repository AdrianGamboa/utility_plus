import 'package:flutter/material.dart';
import 'package:utility_plus/src/screens/dotransfer_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/theme/theme_constants.dart';
import '../database/transfer_db.dart';
import '../models/transfer.dart';
import '../utils/alerts.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({
    Key? key,
    required this.accountList,
  }) : super(key: key);
  final List accountList;
  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  List transferList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Transferencias',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(context),
          ),
        ),
        body: FutureBuilder(
            future: TransferDB.getByUserId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  // Return error
                  return const Center(
                      child: Text('Error al extraer la información'));
                } else {
                  transferList = snapshot.data as List;
                  if (transferList.isEmpty) {
                    return const Center(child: Text('Nada por aquí'));
                  } else {
                    return buildTransfers();
                    // Return Listview with documents data
                  }
                }
              }
            }),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return DotransferPage(
                      accountList: widget.accountList,
                    );
                  }).then((value) {
                if (value != false) {
                  setState(() {});
                }
              });
            },
            child: const Text(
              "+",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ));
  }

  Widget buildTransfers() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
          itemCount: transferList.length,
          itemBuilder: (BuildContext context, int index) {
            return transferCard(index);
          }),
    );
  }

  Widget transferCard(int index) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return DotransferPage(
                  transferInfo: convertToAccount(transferList[index]),
                  accountList: widget.accountList,
                );
              }).then((value) {
            if (value != false) {
              setState(() {});
            }
          });
        },
        child: Column(
          children: [
            Row(children: [
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                    TextSpan(
                        text: '₡ ${transferList[index]['amount'].toString()}\n',
                        style: const TextStyle(height: 1.5)),
                    TextSpan(
                        text: getAccountName(
                            transferList[index]['cuentaDebita'].toString()),
                        style: const TextStyle(height: 1.5)),
                    TextSpan(
                        text: '   ->   ' +
                            getAccountName(transferList[index]['cuentaAcredita']
                                .toString()),
                        style: const TextStyle(height: 1.5)),
                    TextSpan(
                        text:
                            '\n${transferList[index]['transferDate'].toString()}',
                        style: const TextStyle(height: 1.5)),
                  ])),
              const Spacer(),
              SizedBox(
                  height: 30,
                  child: PopupMenuButton<String?>(
                      tooltip: 'Opciones',
                      splashRadius: 24,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        popUpClick(value!, transferList[index]['_id']);
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Eliminar'}.map((String choice) {
                          return PopupMenuItem<String>(
                            height: 25,
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      }))
            ]),
            const Divider(
              color: colorPrimary,
              thickness: 1,
            ),
          ],
        ));
  }

  void popUpClick(String value, m.ObjectId transfer_) {
    if (value == 'Eliminar') {
      delete(transfer_)
          .then((value) => setState(() {}))
          .onError((error, stackTrace) => null);
    }
  }

  Future delete(m.ObjectId account_) async {
    try {
      await TransferDB.delete(account_);
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      setState(() {});
      return Future.error(e);
    }
  }

  Transfer convertToAccount(account_) {
    return Transfer(
        id: account_['_id'],
        description: account_['description'],
        amount: account_['amount'],
        transferDate: account_['transferDate'],
        cuentaDebita: account_['cuentaDebita'],
        cuentaAcredita: account_['cuentaAcredita'],
        uid: account_['uid']);
  }

  getAccountName(id) {
    var contain =
        widget.accountList.where((element) => element['_id'].toString() == id);
    if (contain.isNotEmpty) {
      return contain.toList()[0]['name'];
    }
    return '';
  }
}
