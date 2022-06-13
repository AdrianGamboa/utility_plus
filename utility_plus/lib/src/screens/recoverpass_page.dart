import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/global.dart';

class RecoverPassPage extends StatefulWidget {
  const RecoverPassPage({Key? key}) : super(key: key);

  @override
  State<RecoverPassPage> createState() => _RecoverPassPageState();
}

class _RecoverPassPageState extends State<RecoverPassPage> {
  final emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(context),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60),
              themeManager.themeMode == ThemeMode.light?
                  Image.asset(
                      "assets/images/UtilityC.png",width: 120):Image.asset(
                      "assets/images/UtilityO.png",width: 120),
              const SizedBox(height: 25),
              const Text(
                "¿Has Olvidado tu contraseña?",
                style: TextStyle(
                    
                    fontWeight: FontWeight.w900,
                    fontSize: 20),
              ),
              const SizedBox(height: 25),
              const Text(
                "Ingresa tu correo y te enviaremos los \n"
                "          pasos para recuperarla",
                style: TextStyle(
                    
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 285,
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
              const SizedBox(height: 55),
              SizedBox(
                width: 290,
                child: ElevatedButton(
                  onPressed: () {resetPassword();},
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffAD53AE),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  child: const Text("Recuperar contraseña"),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    emailTextController.addListener(_printEmail);
  }

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
  }

  void _printEmail() {
    // ignore: avoid_print
    print('email: ${emailTextController.text}');
  }

  Future resetPassword() async {
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),),);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextController.text.trim());
    // ignore: use_build_context_synchronously
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}