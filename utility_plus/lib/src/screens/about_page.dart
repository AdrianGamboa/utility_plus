import 'package:flutter/material.dart';
import '../utils/global.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: themeManager.themeMode == ThemeMode.light
                      ? Image.asset("assets/images/UtilityC.png")
                      : Image.asset("assets/images/UtilityO.png"),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  '''
El propósito de la aplicación es brindar una herramienta de control y gestión para la vida cotidiana. Con apartados para la gestión de finanzas, administración de tareas, recordatorios y notas rápidas.
Esta aplicación fue desarrollada con fines académicos como parte del proyecto final del curso de programación en móviles de la Universidad Nacional de Costa Rica, para mejorar los conocimientos técnicos de los estudiantes involucrados.
                  ''',
                  style: TextStyle(
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
                          fontSize: 17.0,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  'Adrian Gamboa Delgado\nDaniel Gurreck Gonzalez\nEsteban Vargas Ureña',
                              style: TextStyle(
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
        ),
      ),
    );
  }
}
