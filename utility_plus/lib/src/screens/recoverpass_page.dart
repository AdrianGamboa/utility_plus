import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/alerts.dart';
import '../utils/global.dart';

class RecoverPassPage extends StatefulWidget {
  const RecoverPassPage({Key? key}) : super(key: key);

  @override
  State<RecoverPassPage> createState() => _RecoverPassPageState();
}

class _RecoverPassPageState extends State<RecoverPassPage> {
  final emailTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loadindicador = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        children: [
          _loadindicador
              ? LinearProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).secondaryHeaderColor)
              : Container(
                  height: 4,
                ),
          SingleChildScrollView(
            reverse: true,
            child: Center(
                child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 60),
                  themeManager.themeMode == ThemeMode.light
                      ? Image.asset("assets/images/UtilityC.png", width: 120)
                      : Image.asset("assets/images/UtilityO.png", width: 120),
                  const SizedBox(height: 25),
                  const Text(
                    "¿Has Olvidado tu contraseña?",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Ingresa tu correo y te enviaremos los \n"
                    "          pasos para recuperarla",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 285,
                    child: TextFormField(
                      controller: emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff707070),
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Llene este campo";
                        }
                        if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value.trim()) ==
                            false) {
                          return "La dirección de correo electronico debe ser válida";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 55),
                  SizedBox(
                    width: 290,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          {
                            resetPassword();
                          }
                          //Se puede mandar mensaje de te has logueado correctamente o un circulo cargando
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      child: const Text("Recuperar contraseña"),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
  }

  Future resetPassword() async {
    try {
      _loadindicador = true;
      setState(() {});
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextController.text.trim());
      // ignore: use_build_context_synchronously
      showSuccessDialog(context, 'Solicitud de cambio de contraseña',
          'Hemos enviado un correo electrónico a ${emailTextController.text} en donde podrás modificar tu contraseña por medio de un enlace adjunto.');
      _loadindicador = false;
      setState(() {});
      // ignore: use_build_context_synchronously
      // Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      String? message = '';
      switch (e.code) {
        case 'user-not-found':
          message =
              'No existe una cuenta de usuario enlazada a la dirección de correo electrónico: ${emailTextController.text}';
          break;
        case 'invalid-email':
          message = 'El correo electónico proporsionado es invalido.';
          break;
        case 'too-many-requests':
          message =
              'Hemos bloqueado todas las solicitudes de este dispositivo debido a que se detecto actividad inusual. Vuelva a intentarlo más tarde.';
          break;

        default:
          message = e.message;
      }
      showAlertDialog(context, 'Error', message!);

      _loadindicador = false;
      setState(() {});
    }
  }

  showSuccessDialog(BuildContext context, String header, String message) {
    // Create button
    Widget okButton = TextButton(
      style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: const Text("OK."),
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(header),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
