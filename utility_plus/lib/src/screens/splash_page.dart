import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/firebase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/mongodatabase.dart';
import 'dart:async';
import '../utils/connection.dart';
import '../utils/global.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool initialConnection = true;
  @override
  void initState() {
    super.initState();
    waitSplash();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print(result.toString());
    if (initialConnection && await hasNetwork()) {
      initialConnection = false;
    } else {
      try {
        print(MongoDatabase.db.state.toString());
        if (result == ConnectivityResult.none) {
          MongoDatabase.db.close();
        } else {
          MongoDatabase.db.close();
          print(MongoDatabase.db.state.toString());
          MongoDatabase.db.open();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        child: themeManager.themeMode == ThemeMode.light
            ? Image.asset("assets/images/UtilityC.png", width: 120)
            : Image.asset("assets/images/UtilityO.png", width: 120),
      )),
    );
  }

  waitSplash() async {
    try {
      if (await hasNetwork()) {
        await MongoDatabase.connect();
        await FireDatabase.initializeFirebase();
        //Valida si el usuario esta logueado
        userFire = authFire.currentUser;

        if (userFire == null) {
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          //print(userFire!.uid.toString());
          Navigator.of(context).pushReplacementNamed('/main');
        }
      } else {
        throw ('Internet error');
      }
    } catch (e) {
      if (e == ("Internet error")) {
        showRepeatAttemptDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showRepeatAttemptDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      setState(() {});
    }
  }

  showRepeatAttemptDialog(BuildContext context, String header, String message) {
    // Create button
    Widget okButton = TextButton(
      style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
      onPressed: () {
        waitSplash();
        Navigator.of(context).pop();
      },
      child: const Text("Volver a intentar."),
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
