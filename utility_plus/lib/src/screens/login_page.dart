import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  //Loguear usuario en la app con email y contraseña, utilizando Firebase
  static Future<a.User?> loginUsingEmailPassword({required String email, required String password, required BuildContext context}) async {
    try {
      UserCredential userCredential = await authFire.signInWithEmailAndPassword(email: email, password: password);
      userFire = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        print("No user found for that email");
        //Faltan mas excepciones y mostrar mensaje de porque no pudo ingresar
      }
    }
    return userFire;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 150,),
              themeManager.themeMode == ThemeMode.light?
              Image.asset(
                  "assets/images/UtilityC.png",width: 120):Image.asset(
                  "assets/images/UtilityO.png",width: 120),
              const SizedBox(height: 30,),
              SizedBox(
                width: 300,
                child: TextField(
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
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffAD53AE),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordTextController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff707070),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffAD53AE),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              Container(
                margin: const EdgeInsets.all(60),
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    a.User? user = await loginUsingEmailPassword(email: emailTextController.text, password: passwordTextController.text, context: context);
                    print(user);
                    if(user != null){
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacementNamed('/main');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffAD53AE),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Ingresar"),
                ),
              ),
              Text.rich(
                TextSpan(
                  text: "¿Has olvidado tu contraseña? ",
                  style: const TextStyle(color: Color(0xff707070)),
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
                  style: const TextStyle(color: Color(0xff707070)),
                  children: [
                    TextSpan(
                      text: "Registrate",
                      style: const TextStyle(
                          color: Color(0xffad53ae), fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed("/register");
                        },
                    )
                  ],
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
