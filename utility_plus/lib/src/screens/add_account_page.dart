import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:utility_plus/src/database/account_db.dart';
import 'package:utility_plus/src/models/account.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/utils/global.dart';

import '../utils/alerts.dart';

IconData iconChoosed = Icons.monetization_on;

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({Key? key, this.accountInfo}) : super(key: key);

  final Account? accountInfo;

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  Color? _tempShadeColor;
  Color? _shadeColor = Colors.orange[100];
  Color? _tempMainColor;
  Color? _mainColor = Colors.orange;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final amountTextController = TextEditingController();

  bool update = false;

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
                      updateAccount()
                          .then((value) => Navigator.of(context).pop(true))
                          .onError((error, stackTrace) => null);
                    } else {
                      insertAccount()
                          .then((value) => Navigator.of(context).pop(true))
                          .onError((error, stackTrace) => null);
                    }
                  }
                },
                child: const Text("Guardar"))
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
      !update
          ? const Text("Agregar cuenta",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20))
          : const Text("Modificar cuenta",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey,
          child: Column(
            children: [
              textForm('Nombre', 1, 18, nameTextController, false, true),
              const SizedBox(height: 20),
              textForm('Monto', 1, 10, amountTextController, true, false),
            ],
          )),
      const SizedBox(height: 30),
      const IconPicker(),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Seleccione un color: "),
          IconButton(
            splashRadius: 25,
            iconSize: 35,
            icon: Icon(
              Icons.circle,
              color: _shadeColor!,
            ),
            onPressed: () {
              _openColorPicker();
            },
          ),
        ],
      ),
      const SizedBox(height: 20),
    ]);
  }

  Widget textForm(name, lines, lenght, controller, numKeyboard, band) {
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
              if (band == true) {
                if (nameTextController.text == '') return 'Ingrese un nombre';
              } else if (band == false) {
                if (amountTextController.text == '') return 'Ingrese un monto';
              }
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

  initTaskInfo() {
    if (widget.accountInfo != null) {
      nameTextController.text = widget.accountInfo!.name;
      amountTextController.text = widget.accountInfo!.amount.toString();
      iconChoosed =
          IconData(widget.accountInfo!.icon, fontFamily: 'MaterialIcons');
      _shadeColor = Color(widget.accountInfo!.color);
      update = true;
    }
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    nameTextController.clear();
    amountTextController.clear();
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor == Colors.white ? _mainColor : _shadeColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  Future insertAccount() async {
    try {
      await AccountDB.insert(Account(
          id: m.ObjectId(),
          name: nameTextController.text,
          amount: int.parse(amountTextController.text),
          icon: iconChoosed.codePoint,
          color: _shadeColor!.value,
          uid: userFire!.uid.toString()));
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

  Future updateAccount() async {
    try {
      await AccountDB.update(Account(
          id: widget.accountInfo!.id,
          name: nameTextController.text,
          amount: int.parse(amountTextController.text),
          icon: iconChoosed.codePoint,
          color: _shadeColor!.value,
          uid: widget.accountInfo!.uid));
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
}

class IconPicker extends StatefulWidget {
  static List<IconData> icons = [
    Icons.monetization_on,
    Icons.money_rounded,
    Icons.add_card,
    Icons.add_chart_outlined,
    Icons.cases_rounded,
    Icons.account_balance,
    Icons.insert_chart_outlined_outlined,
    Icons.shopify_rounded,
    Icons.trending_up,
    Icons.collections_bookmark,
    Icons.money_off_outlined,
    Icons.account_balance_wallet_rounded
  ];

  const IconPicker({Key? key}) : super(key: key);

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Seleccione un icono:"),
        const SizedBox(height: 5),
        Wrap(
          spacing: 5,
          children: <Widget>[
            for (var icon in IconPicker.icons)
              GestureDetector(
                onTap: () {
                  setState(() {
                    iconChoosed = icon;
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3.0)),
                        border: Border.all(
                            color: iconChoosed == icon
                                ? Colors.blueAccent
                                : Colors.transparent)),
                    child: Icon(icon, size: 30)),
              )
          ],
        ),
      ],
    );
  }
}
