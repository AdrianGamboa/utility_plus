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
            title: Row(
              children: [
                const Text('Acerca de'),
                const Spacer(),
                Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.import_contacts),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/conditionsterms');
                      },
                    )),
              ],
            ),
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).focusColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.all(20),
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
                  Text('Sobre la App',
                      style: Theme.of(context).textTheme.titleLarge),
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
                        text: TextSpan(
                          text: 'Desarrolladores:\n',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize: 17.0,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '\t\t\tAdrian Gamboa Delgado\n\t\t\tDaniel Gurreck Gonzalez\n\t\t\tEsteban Vargas Ureña',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
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
      ),
    );
  }
}
