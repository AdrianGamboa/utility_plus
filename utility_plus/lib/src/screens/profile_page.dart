import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';
import '../database/users_db.dart';
import '../services/AuthenticationServices.dart';
import '../utils/global.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> getUser;
  late User user;
  String themeMode = '';
  @override
  void initState() {
    _getUser();
    themeMode = GetStorage().read('theme');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: IconButton(
                  onPressed: () async {
                    if (GetStorage().read('theme') == 'auto') {
                      GetStorage().write('theme', 'dark');
                      themeMode = 'dark';
                    } else if (GetStorage().read('theme') == 'dark') {
                      GetStorage().write('theme', 'light');
                      themeMode = 'light';
                    } else {
                      GetStorage().write('theme', 'auto');
                      themeMode = 'auto';
                    }
                    themeManager.notifyListeners();
                    setState(() {});
                  },
                  icon: (themeMode == 'auto')
                      ? const Icon(Icons.brightness_auto_sharp)
                      : (themeMode == 'dark')
                          ? const Icon(Icons.nightlight)
                          : const Icon(Icons.sunny),
                ),
              ),
              SizedBox(
                height: 70,
                width: 70,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/about');
                  },
                  icon: const Icon(
                    Icons.info,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            height: 150,
            child: themeManager.themeMode == ThemeMode.light
                ? Image.asset("assets/images/UtilityC.png")
                : Image.asset("assets/images/UtilityO.png"),
          ),
          const Spacer(),
          ReRunnableFutureBuilder(getUser,
              getUserInformation: getUserInformation),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                AuthenticationService()
                    .signOut(context)
                    .then((value) =>
                        Navigator.of(context).pushReplacementNamed('/login'))
                    .onError((error, stackTrace) => setState(() {}));
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout),
                  SizedBox(width: 5),
                  Text('Cerrar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _getUser() async {
    try {
      setState(() {
        getUser = UserDB.getCurrentUser();
      });
      dynamic u = await getUser;
      user = User.fromMap(u);
    } catch (e) {}
  }

  List<Widget> getUserInformation(data, context) {
    List<Widget> userData = [];

    userData.add(Container(
      width: 300,
      margin: const EdgeInsets.only(top: 20),
      child: AutoSizeText(
          data['nombre'] +
              ' ' +
              data['primerApellido'] +
              ' ' +
              data['segundoApellido'],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ));
    userData.add(Container(
      width: 300,
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      child: AutoSizeText(data['email'],
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xff707070),
              fontWeight: FontWeight.w500)),
    ));

    return userData;
  }
}

class ReRunnableFutureBuilder extends StatelessWidget {
  final Future<Map<String, dynamic>?> _future;

  const ReRunnableFutureBuilder(this._future,
      {Key? key, required this.getUserInformation})
      : super(key: key);

  final Function getUserInformation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Text("Error al extraer la información");
          }

          return Column(
            children: getUserInformation(snapshot.data, context),
          );
        });
  }
}
