import 'package:firebase_core/firebase_core.dart';

class FireDatabase {
  //Metodo para inicializar base de datos Firebase en la app
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
}