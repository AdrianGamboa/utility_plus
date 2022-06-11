import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
const MONGO_CONN_URL = "mongodb+srv://danielgg:una@cluster0.7fvnk7o.mongodb.net/infinity+";
const USER_COLLECTION = "usuarios";
 FirebaseAuth authFire = FirebaseAuth.instance;
    a.User? userFire;