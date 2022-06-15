import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/account_db.dart';
import 'package:utility_plus/src/models/account.dart';
import 'package:utility_plus/src/screens/addAccount_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List accountList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuentas',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: FutureBuilder(
          future: AccountDB.getByUserId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                // Return error
                return const Center(child: Text('error'));
              } else {
                accountList = snapshot.data as List;
                if (accountList.isEmpty) {
                  return const Center(child: Text('Nada por aquí'));
                } else {
                  return buildAccounts();
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
                  return const AddAccountPage();
                }).then((value) => setState(() {}));
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget buildAccounts() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
          itemCount: accountList.length,
          itemBuilder: (BuildContext context, int index) {
            return accountCard(index);
          }),
    );
  }

  Widget accountCard(int index) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AddAccountPage(
                    accountInfo: convertToAccount(accountList[index]));
              }).then((value) => setState(() {}));
        },
        child: Row(children: [
          Icon(
              IconData(accountList[index]['icon'], fontFamily: 'MaterialIcons'),
              color: Color(accountList[index]['color'])),
          const SizedBox(width: 20),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                TextSpan(
                    text: '${accountList[index]['name']}\n',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: '₡ ${accountList[index]['amount'].toString()}',
                    style: const TextStyle(height: 1.5))
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
                    popUpClick(value!, accountList[index]['_id']);
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
      delete(account_).then((value) => setState(() {}));
    }
  }

  Future delete(m.ObjectId account_) async {
    await AccountDB.delete(account_);
  }

  Account convertToAccount(account_) {
    return Account(
        id: account_['_id'],
        name: account_['name'],
        amount: account_['amount'],
        icon: account_['icon'],
        color: account_['color'],
        uid: account_['uid']);
  }
}
