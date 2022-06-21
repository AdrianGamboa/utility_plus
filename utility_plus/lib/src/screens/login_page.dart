import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../utils/alerts.dart';
import '../utils/global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  //Loguear usuario en la app con email y contraseña, utilizando Firebase
  static Future<a.User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await authFire.signInWithEmailAndPassword(
          email: email, password: password);
      userFire = userCredential.user;
    } on FirebaseAuthException catch (e) {
      String? message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado.';
          break;
        case 'invalid-email':
          message = 'El correo electrónico proporcionado es inválido.';
          break;
        case 'wrong-password':
          message =
              'La contraseña no es válida o el usuario no tiene contraseña.';
          break;
        case 'invalid-credential':
          message = 'Los credenciales proporcionados son inválidos.';
          break;
        case 'too-many-requests':
          message =
              'Hemos bloqueado todas las solicitudes de este dispositivo debido a que se detectó actividad inusual. Vuelva a intentarlo más tarde.';
          break;

        default:
          message = e.message;
      }
      showAlertDialog(context, 'Error', message!);
    }
    return userFire;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              themeManager.themeMode == ThemeMode.light
                  ? Image.asset("assets/images/UtilityC.png", width: 120)
                  : Image.asset("assets/images/UtilityO.png", width: 120),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: emailTextController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Llene este campo';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: passwordTextController,
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Contraseña",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Llene este campo';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(60),
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      {
                        a.User? user = await loginUsingEmailPassword(
                            email: emailTextController.text,
                            password: passwordTextController.text,
                            context: context);
                        //print(user);
                        if (user != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushReplacementNamed('/main');
                        }
                      }
                      //Se puede mandar mensaje de te has logueado correctamente o un circulo cargando
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Ingresar"),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: "¿Has olvidado tu contraseña? ",
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed('/recoverPass');
                    },
                ),
              ),
              const SizedBox(height: 15),
              Text.rich(
                TextSpan(
                  text: "¿Aún no tienes cuenta? ",
                  children: [
                    TextSpan(
                      text: "Registrate",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed("/register");
                        },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    ));
  }
}
