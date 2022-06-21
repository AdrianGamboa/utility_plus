// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:utility_plus/src/database/users_db.dart';
import 'package:utility_plus/src/utils/alerts.dart';
import 'package:utility_plus/src/utils/connection.dart';
import 'package:utility_plus/src/utils/global.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(
      String nombre,
      String primerApellido,
      String segundoApellido,
      String email,
      String password,
      BuildContext context) async {
    try {
      UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        UserDB.registerUser(nombre, primerApellido, segundoApellido, email,
            value.user!.uid.toString());
        return value;
      });
      User? user = credential.user;
      userFire = user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          await showAlertDialog(context, '', 'El email ya está en uso');
          break;
        case 'invalid-email':
          await showAlertDialog(context, '', 'Email inválido');
          break;
        case 'operation-not-allowed':
          await showAlertDialog(context, '', 'Operación no permitida');
          break;
        case 'weak-password':
          await showAlertDialog(context, '', 'Contraseña débil');
          break;
        default:
          await showAlertDialog(context, '', 'Error desconocido');
          break;
      }
      Navigator.of(context).pop();
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
      if (await hasNetwork()) {
        await _auth.signOut();
        userFire = null;
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else if (e == ('Email is not valid')) {
        showAlertDialog(context, 'Problema de datos',
            'El correo electrónico proporcionado es inválido.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      return Future.error(e);
    }
  }
}
