import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/firebase.dart';

import '../utils/global.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    waitSplash();
    FireDatabase.initializeFirebase();

    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
          child: SizedBox(
        child: themeManager.themeMode == ThemeMode.light?
              Image.asset(
                  "assets/images/UtilityC.png",width: 120):Image.asset(
                  "assets/images/UtilityO.png",width: 120),
      )),
    );
  }

  waitSplash() async {
    await Future.delayed(const Duration(seconds: 3), () {
      //Valida si el usuario esta logueado
      userFire = authFire.currentUser;
      if (userFire == null) {
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        print(userFire!.uid.toString());
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
  }
}
  