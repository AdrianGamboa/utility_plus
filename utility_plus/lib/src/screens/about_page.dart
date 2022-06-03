import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutPage> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: const Text('Acerca de'),
          )),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Image.asset("assets/UtilityC.png"),
            ),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vel efficitur dui. Curabitur eu metus nisl. Maecenas tempus, neque eu maximus pellentesque, mi sapien commodo neque, nec viverra quam enim eu nunc. Aenean lobortis sapien pretium dapibus fringilla. Sed vitae dui at tellus fermentum viverra at a sapien. Pellentesque bibendum tellus at massa rhoncus, at pharetra lorem rhoncus. Nulla porta dapibus purus quis commodo. ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    text: 'Desarrolladores:\n',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'Adrian Gamboa Delgado - correo@gmail.com\nDaniel Gurreck Gonzalez - correo@gmail.com\nEsteban Vargas Ureña - correo@gmail.com',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            height: 1.8,
                            fontWeight: FontWeight.normal,
                          )),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
