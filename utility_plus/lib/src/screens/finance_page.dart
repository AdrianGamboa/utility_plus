// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/account_db.dart';
import 'package:utility_plus/src/database/transaction_db.dart';
import 'package:utility_plus/src/models/transaction.dart';
import 'package:utility_plus/src/screens/transaction_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

import '../utils/alerts.dart';
import 'transfer_page.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  String amount = '0';

  late String? selectedValue = '';
  late Future<List<Map<String, dynamic>>> _listAccounts;
  List accountList = [];
  List transactionList = [];

  @override
  void initState() {
    super.initState();
    getAccounts();

    selectedValue = 'Total';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: AppBar(
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.monetization_on,
                              size: 35, color: Colors.white),
                          const SizedBox(width: 10),
                          selectedValue != ''
                              ? buildAccounts()
                              : const CircularProgressIndicator()
                        ],
                      ),
                      const Spacer(),
                      Container(
                          // margin: const EdgeInsets.only(top: 14.0),
                          child: selectedValue != null
                              ? Text(
                                  amount.length > 10
                                      ? '${amount.substring(0, 12)}...'
                                      : amount,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34 - amount.length.toDouble(),
                                      fontWeight: FontWeight.w700))
                              : const Text(
                                  '₡ 0',
                                )),
                      const SizedBox(height: 30)
                    ],
                  ),
                ),
                bottom: const TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Color(0xffAD53AE),
                    unselectedLabelColor: Colors.white54,
                    tabs: [
                      Tab(child: Text('Gastos')),
                      Tab(child: Text('Ingresos'))
                    ]))),
        body: TabBarView(children: [
          transactionContent("Expense"),
          transactionContent("Income")
        ]),
        persistentFooterButtons: <Widget>[
          RaisedButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed('/accounts');
              if (result == true) {
                getAccounts();
                selectedValue = 'Total';
                setState(() {});
              }
            },
            child: const Text("Cuentas"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TransferPage(accountList: accountList)));
            },
            child: const Text("Transferencias"),
          ),
        ],
      ),
    );
  }

  Stack transactionContent(type) {
    return Stack(children: [
      FutureBuilder(
          future: selectedValue == '' || selectedValue == 'Total'
              ? TransactionDB.getByType(type)
              : TransactionDB.getByTypeAndAccount(
                  type, m.ObjectId.parse(selectedValue!.substring(10, 34))),
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
                transactionList = snapshot.data as List;
                if (transactionList.isEmpty) {
                  return const Center(child: Text('Nada por aquí'));
                } else {
                  return buildTransactions(type);
                  // Return Listview with documents data
                }
              }
            }
          }),
      Align(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return TransactionPage(
                                  accountList: accountList, type: type);
                            }).then((value) {
                          if (value) {
                            getAccounts();
                            setState(() {});
                          }
                        });
                      },
                      child: const Icon(Icons.add)))))
    ]);
  }

  Widget buildTransactions(String type) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: transactionList.length,
          itemBuilder: (BuildContext context, int index) {
            return transactionCard(index, type);
          }),
    );
  }

  Widget transactionCard(int index, String type) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return TransactionPage(
                    accountList: accountList,
                    type: type,
                    transactionInfo:
                        convertToTransaction(transactionList[index]));
              }).then((value) {
            if (value) {
              getAccounts();
              setState(() {});
            }
          });
        },
        child: Row(children: [
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                TextSpan(
                    text: '${transactionList[index]['title']}\n',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        '${transactionList[index]['transactionDate'].toString()} | ',
                    style: const TextStyle(height: 1.5)),
                TextSpan(
                    text: '₡ ${transactionList[index]['amount'].toString()}',
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
                    popUpClick(value!, transactionList[index]['_id']);
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
        ]));
  }

  void popUpClick(String value, m.ObjectId account_) {
    if (value == 'Eliminar') {
      delete(account_).then((value) {
        setState(() {});
      });
    }
  }

  Transaction convertToTransaction(transaction_) {
    return Transaction(
        id: transaction_['_id'],
        title: transaction_['title'],
        description: transaction_['description'],
        amount: transaction_['amount'],
        transactionDate: transaction_['transactionDate'],
        type: transaction_['type'],
        accountId: transaction_['accountId'],
        uid: transaction_['uid']);
  }

  Future delete(m.ObjectId transaction_) async {
    try {
      await TransactionDB.delete(transaction_);
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

  getAmount() {
    if (selectedValue != 'Total') {
      var contain = accountList
          .where((element) => element['_id'].toString() == selectedValue);

      if (contain.isNotEmpty) {
        setState(() {
          amount = '₡ ${contain.toList()[0]['amount'].toString()}';
        });
      }
    } else {
      num total = 0;
      for (var element in accountList) {
        total = total + element['amount'];
      }
      setState(() {
        amount = '₡ $total';
      });
    }
  }

  buildAccounts() {
    List<DropdownMenuItem<String>> itemList = [];
    itemList.add(const DropdownMenuItem(value: "Total", child: Text("Total")));

    for (var element in accountList) {
      itemList.add(DropdownMenuItem(
          value: element['_id'].toString(), child: Text(element['name'])));
    }

    return DropdownButton(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      iconEnabledColor: Colors.white,
      value: selectedValue,
      items: itemList,
      selectedItemBuilder: (BuildContext ctxt) {
        return itemList.map<Widget>((item) {
          return DropdownMenuItem(
              value: item.value,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                    item.child
                        .toString()
                        .substring(6, item.child.toString().length - 2),
                    style: const TextStyle(color: Colors.white)),
              ));
        }).toList();
      },
      onChanged: (String? value) {
        setState(() {
          selectedValue = value!;
        });
        getAmount();
      },
    );
  }

  getAccounts() async {
    try {
      _listAccounts = AccountDB.getByUserId();
      accountList = await _listAccounts;

      getAmount();
    } catch (e) {}
  }
}
