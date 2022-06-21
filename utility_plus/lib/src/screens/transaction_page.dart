import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:utility_plus/src/database/account_db.dart';
import 'package:utility_plus/src/database/transaction_db.dart';
import 'package:utility_plus/src/models/transaction.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/utils/global.dart';
import '../utils/alerts.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage(
      {Key? key,
      this.transactionInfo,
      required this.type,
      required this.accountList})
      : super(key: key);

  final Transaction? transactionInfo;
  final String type;
  final List accountList;
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final amountTextController = TextEditingController();
  final dateTextController = TextEditingController();
  late String? selectedValue = '';
  DateTime? date;
  bool update = false;
  int originalAmount = 0;

  @override
  void initState() {
    super.initState();
    initTaskInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancelar")),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (update) {
                      updateTransaction().then((value) {
                        updateAccount(value.accountId, value.amount)
                            .then((value) => Navigator.of(context).pop(true))
                            .onError((error, stackTrace) => null);
                      }).onError((error, stackTrace) => null);
                    } else {
                      if (widget.type == 'Expense') {
                        if (getAccountAmount() >
                            int.parse(amountTextController.text)) {
                          insertTransaction().then((value) {
                            updateAccount(value.accountId, value.amount * -1)
                                .then(
                                    (value) => Navigator.of(context).pop(true))
                                .onError((error, stackTrace) => null);
                          }).onError((error, stackTrace) => null);
                        } else {
                          noFundsDialog();
                        }
                      } else if (widget.type == 'Income') {
                        insertTransaction().then((value) {
                          updateAccount(value.accountId, value.amount)
                              .then((value) => Navigator.of(context).pop(true))
                              .onError((error, stackTrace) => null);
                        }).onError((error, stackTrace) => null);
                      }
                    }
                  }
                },
                child: const Text("Guardar"))
          ],
          content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: dialogContent()))),
    );
  }

  Widget dialogContent() {
    return Column(children: [
      !update
          ? Text(widget.type == 'Expense' ? "Agregar gasto" : "Agregar ingreso",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
          : Text(
              widget.type == 'Expense'
                  ? "Modificar gasto"
                  : "Modificar ingreso",
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(
            children: [
              textForm(
                'Título',
                1,
                18,
                titleTextController,
                false,
              ),
              const SizedBox(height: 20),
              textForm(
                  'Descripción', 2, null, descriptionTextController, false),
              const SizedBox(height: 20),
              textForm('Monto', 1, null, amountTextController, true),
              const SizedBox(height: 20),
              datePicker(),
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerLeft, child: dropDown()),
            ],
          )),
    ]);
  }

  Widget textForm(name, lines, lenght, controller, numKeyboard) {
    return SizedBox(
        width: 320,
        child: TextFormField(
            inputFormatters:
                numKeyboard ? [FilteringTextInputFormatter.digitsOnly] : null,
            keyboardType:
                numKeyboard ? TextInputType.number : TextInputType.text,
            maxLength: lenght,
            maxLines: lines,
            minLines: 1,
            controller: controller,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (titleTextController.text == '') return 'Ingrese un nombre';
              if (amountTextController.text == '') return 'Ingrese un monto';
              return null;
            },
            decoration: InputDecoration(
              counterText: "",
              suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  iconSize: 18,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.clear();
                  },
                  icon: const Icon(Icons.clear)),
              labelText: name,
            )));
  }

  dropDown() {
    List<DropdownMenuItem<String>> itemList = [];

    for (var element in widget.accountList) {
      itemList.add(DropdownMenuItem(
          value: element['_id'].toString(), child: Text(element['name'])));
    }

    return DropdownButtonFormField(
      decoration: const InputDecoration(),
      isExpanded: true,
      validator: (value) {
        if (selectedValue == '') return 'Seleccione una cuenta';
        return null;
      },
      value: update ? selectedValue : null,
      hint: const Text('Seleccione una cuenta'),
      items: itemList,
      onChanged: !update
          ? (String? value) {
              setState(() {
                selectedValue = value!;
              });
            }
          : null,
    );
  }

  Row datePicker() {
    return Row(children: [
      SizedBox(
          width: 210,
          child: TextFormField(
              readOnly: true,
              controller: dateTextController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: widget.type == 'Expense'
                    ? "Fecha del gasto"
                    : "Fecha del ingreso",
              ))),
      const SizedBox(width: 10),
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            pickDate(context).then((value) => dateTextController.text =
                '${date!.day}/${date!.month}/${date!.year}');
          },
          icon: const Icon(Icons.calendar_month))
    ]);
  }

  noFundsDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("No hay fondos suficientes"),
        content: const Text("Disminuya el monto del gasto."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  initTaskInfo() {
    if (widget.transactionInfo != null) {
      titleTextController.text = widget.transactionInfo!.title;
      descriptionTextController.text = widget.transactionInfo!.description;
      amountTextController.text = widget.transactionInfo!.amount.toString();
      dateTextController.text = widget.transactionInfo!.transactionDate;
      selectedValue = widget.transactionInfo!.accountId.toString();
      originalAmount = widget.transactionInfo!.amount;
      update = true;
    } else {
      var formatter = DateFormat('dd/M/yyyy');
      dateTextController.text = formatter.format(DateTime.now().toLocal());
    }
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    titleTextController.clear();
    amountTextController.clear();
  }

  Future<Transaction> insertTransaction() async {
    try {
      Transaction transaction = Transaction(
          id: m.ObjectId(),
          title: titleTextController.text,
          description: descriptionTextController.text,
          amount: int.parse(amountTextController.text),
          transactionDate: dateTextController.text,
          type: widget.type,
          accountId: m.ObjectId.parse(selectedValue!.substring(10, 34)),
          uid: userFire!.uid.toString());

      await TransactionDB.insert(transaction);
      return transaction;
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

  Future<Transaction> updateTransaction() async {
    try {
      Transaction transaction = Transaction(
          id: widget.transactionInfo!.id,
          title: titleTextController.text,
          description: descriptionTextController.text,
          amount: int.parse(amountTextController.text),
          transactionDate: dateTextController.text,
          type: widget.transactionInfo!.type,
          accountId: m.ObjectId.parse(selectedValue!.substring(10, 34)),
          uid: widget.transactionInfo!.uid);

      await TransactionDB.update(transaction);
      return transaction;
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

  Future updateAccount(m.ObjectId accountId, int amount) async {
    try {
      if (update) {
        amount = widget.type == 'Expense'
            ? originalAmount - amount
            : amount - originalAmount;
        await AccountDB.updateAmount(accountId, amount);
      } else {
        await AccountDB.updateAmount(accountId, amount);
      }
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

  String getAccountId() {
    var contain = widget.accountList
        .where((element) => element['_id'].toString() == selectedValue);

    if (contain.isNotEmpty) return contain.toList()[0]['amount'];
    return '';
  }

  int getAccountAmount() {
    var contain = widget.accountList
        .where((element) => element['_id'].toString() == selectedValue);

    if (contain.isNotEmpty) return contain.toList()[0]['amount'];
    return 0;
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now().toLocal();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));

    if (newDate == null) {
      return null;
    } else {
      date = newDate;
      return newDate;
    }
  }
}
