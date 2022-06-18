// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:utility_plus/src/database/users_db.dart';
import 'package:utility_plus/src/utils/alerts.dart';
import 'package:utility_plus/src/utils/global.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(String nombre, String primerApellido, String segundoApellido, String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((value) {
            UserDB.registerUser(nombre, primerApellido, segundoApellido, email,value.user!.uid.toString());
            return value;});
      User? user = credential.user;
      userFire=user;
      return user;
    }on FirebaseAuthException catch (e){
      switch(e.code) {
        case 'email-already-in-use':
          showAlertDialog(context, '', 'El email ya está en uso',2);
          break;
        case 'invalid-email':
          showAlertDialog(context, '', 'Email inválido',2);
          break;
        case 'operation-not-allowed':
          showAlertDialog(context, '', 'Operación no permitida',2);
          break;
        case 'weak-password':
        showAlertDialog(context, '', 'Contraseña débil',2);
          break;
        default:
        showAlertDialog(context, '', 'Error desconocido',2);
          break;

      }
    }
  }

// sign with email and password

  Future loginUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e.toString());
    }
  }

// signout

  Future signOut(BuildContext context) async {
    try {
      Navigator.of(context).pushReplacementNamed('/login');
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}