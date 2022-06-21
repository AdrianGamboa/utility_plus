// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:utility_plus/src/database/transfer_db.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/utils/global.dart';

import '../database/account_db.dart';
import '../models/account.dart';
import '../models/transfer.dart';
import '../utils/alerts.dart';

IconData iconChoosed = Icons.monetization_on;

class DotransferPage extends StatefulWidget {
  const DotransferPage({Key? key, required this.accountList, this.transferInfo})
      : super(key: key);
  final List accountList;
  final Transfer? transferInfo;
  @override
  State<DotransferPage> createState() => _DotransferPageState();
}

class _DotransferPageState extends State<DotransferPage> {
  DateTime? date;
  TimeOfDay? time;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final amountTextController = TextEditingController();
  final dateTextController = TextEditingController();
  late String selectedValue1 = '';
  late String selectedValue2 = '';
  bool band = false;
  bool update = false;

  @override
  void initState() {
    super.initState();
    initTransferInfo();
    var formatter = DateFormat('yyyy-MM-dd hh:mm');
    dateTextController.text = formatter.format(DateTime.now().toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(false);
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
                      updateTransfer().then((value) {
                        if (value) {
                          updateAccount(selectedValue1, true).then((value) {
                            updateAccount(selectedValue2, false)
                                .then((value) => clearTxt())
                                .onError((error, stackTrace) => null);
                          }).onError((error, stackTrace) => null);

                          Navigator.of(context).pop();
                        } else {
                          dialog();
                        }
                      }).onError((error, stackTrace) => null);
                    } else {
                      insertTransfer().then((value) {
                        if (value) {
                          updateAccount(selectedValue1, true).then((value) {
                            updateAccount(selectedValue2, false)
                                .then((value) => clearTxt())
                                .onError((error, stackTrace) => null);
                          }).onError((error, stackTrace) => null);
                          Navigator.of(context).pop();
                        } else {
                          dialog();
                        }
                      }).onError((error, stackTrace) => null);
                    }
                  }
                },
                child: const Text("Guardar")),
          ],
          content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 380,
                  child: dialogContent()))),
    );
  }

  Widget dialogContent() {
    return Column(children: [
      const Text("Realizar Transferencia",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(
            children: [
              textForm('Monto', 1, null, amountTextController, true),
              const SizedBox(height: 20),
              textForm('Descripción', 1, 18, nameTextController, false),
              const SizedBox(height: 20),
              dateTimePicker(),
              const SizedBox(height: 20),
              dropDown1(
                'Escoger la cuenta a debitar',
              ),
              const SizedBox(height: 20),
              dropDown2(
                'Escoger la cuenta a acreditar',
              ),
            ],
          )),
      const SizedBox(height: 30),
      //const IconPicker(),
      const SizedBox(height: 20),

      const SizedBox(height: 20),
    ]);
  }

  Row dateTimePicker() {
    return Row(children: [
      Expanded(
          child: TextFormField(
              readOnly: true,
              controller: dateTextController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    iconSize: 18,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      dateTextController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                labelText: 'Fecha Transferencia',
              ))),
      const SizedBox(width: 10),
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            pickDateTime(context);
          },
          icon: const Icon(Icons.date_range))
    ]);
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 5));

    if (newDate == null) {
      return null;
    } else {
      date = newDate;
      return newDate;
    }
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialTime);

    if (newTime == null) {
      return null;
    } else {
      time = newTime;
      return newTime;
    }
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;
    if (!mounted) return;
    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      dateTextController.text =
          '${date.day}/${date.month}/${date.year} $hours:$minutes';
    });
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
              if (nameTextController.text == '') return 'Ingrese un nombre';
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

  dropDown1(title) {
    List<DropdownMenuItem<String>> itemList = [];

    for (var element in widget.accountList) {
      itemList.add(DropdownMenuItem(
          value: element['_id'].toString(), child: Text(element['name'])));
    }

    return DropdownButtonFormField(
      isExpanded: true,
      validator: (value) {
        if (selectedValue1 == '') return 'Seleccione una cuenta';
        return null;
      },
      value: update ? selectedValue1 : null,
      hint: Text(title),
      items: itemList,
      onChanged: !update
          ? (String? value) {
              setState(() {
                selectedValue1 = value!;
              });
            }
          : null,
    );
  }

  dropDown2(title) {
    List<DropdownMenuItem<String>> itemList = [];

    for (var element in widget.accountList) {
      itemList.add(DropdownMenuItem(
          value: element['_id'].toString(), child: Text(element['name'])));
    }

    return DropdownButtonFormField(
      isExpanded: true,
      validator: (value) {
        if (selectedValue2 == '') return 'Seleccione una cuenta';
        return null;
      },
      value: update ? selectedValue2 : null,
      hint: Text(title),
      items: itemList,
      onChanged: !update
          ? (String? value) {
              setState(() {
                selectedValue2 = value!;
              });
            }
          : null,
    );
  }

  initTransferInfo() {
    if (widget.transferInfo != null) {
      nameTextController.text = widget.transferInfo!.description;
      amountTextController.text = widget.transferInfo!.amount.toString();
      dateTextController.text = widget.transferInfo!.transferDate!;
      selectedValue1 = widget.transferInfo!.cuentaDebita.toString();
      selectedValue2 = widget.transferInfo!.cuentaAcredita.toString();
      update = true;
    }
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    nameTextController.clear();
    amountTextController.clear();
    dateTextController.clear();
    selectedValue1 = '';
    selectedValue2 = '';
    band = false;
  }

  getAccountAmount(id) {
    var contain =
        widget.accountList.where((element) => element['_id'].toString() == id);
    if (contain.isNotEmpty) {
      return contain.toList()[0]['amount'];
    }
    return '';
  }

  Future updateAccount(id, bandera) async {
    try {
      var contain = widget.accountList
          .where((element) => element['_id'].toString() == id);
      await AccountDB.update(Account(
          id: contain.toList()[0]['_id'],
          name: contain.toList()[0]['name'],
          amount: bandera == true
              ? contain.toList()[0]['amount'] -
                  int.parse(amountTextController.text)
              : contain.toList()[0]['amount'] +
                  int.parse(amountTextController.text),
          icon: contain.toList()[0]['icon'],
          color: contain.toList()[0]['color'],
          uid: contain.toList()[0]['uid']));
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

  Future insertTransfer() async {
    try {
      if (getAccountAmount(selectedValue1) >
          int.parse(amountTextController.text)) {
        await TransferDB.insert(Transfer(
            id: m.ObjectId(),
            description: nameTextController.text,
            amount: int.parse(amountTextController.text),
            transferDate: dateTextController.text,
            cuentaDebita: m.ObjectId.parse(selectedValue1.substring(10, 34)),
            cuentaAcredita: m.ObjectId.parse(selectedValue2.substring(10, 34)),
            uid: userFire!.uid.toString()));
        return true;
      } else {
        return false;
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

  Future updateTransfer() async {
    try {
      if (getAccountAmount(selectedValue1) >
          int.parse(amountTextController.text)) {
        await TransferDB.update(Transfer(
          id: widget.transferInfo!.id,
          description: nameTextController.text,
          amount: int.parse(amountTextController.text),
          cuentaDebita: m.ObjectId.parse(selectedValue1.substring(10, 34)),
          cuentaAcredita: m.ObjectId.parse(selectedValue2.substring(10, 34)),
          transferDate: dateTextController.text,
        ));
        return true;
      } else {
        return false;
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

  dialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Fondos insuficientes"),
        content: const Text("No se puede realizar la transferencia"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
