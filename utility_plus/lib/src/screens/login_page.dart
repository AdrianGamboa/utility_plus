import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../database/database.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
      child: Center(
          child: Column(
        children: <Widget>[
          Image.asset(
              "assets/images/UtilityC.png",width: 350,height: 300,),
          SizedBox(
            width: 300,
            child: TextField(
              controller: emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                   
                    width: 1.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    
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
          SizedBox(height: 50,),

          Container(
            margin: const EdgeInsets.all(60),
            width: 400,
            child: ElevatedButton(
              child: const Text("Ingresar"),
              onPressed: () {
                MongoDatabase.getDocuments();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffAD53AE),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          
          Text.rich(
            TextSpan(
              text: "¿Has olvidado tu contraseña? ",
              style: TextStyle(color: Color(0xff707070)),
               recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed("/register");
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
      )),
    )
    );
  }
}