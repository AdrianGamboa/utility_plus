import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        child: Image.asset("assets/images/UtilityC.png"),
      )),
    );
  }

  waitSplash() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/main');
    });
  }
}
