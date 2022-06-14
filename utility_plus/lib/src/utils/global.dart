import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/theme_manager.dart';

const mongoConnUrl =
    "mongodb+srv://danielgg:una@cluster0.7fvnk7o.mongodb.net/infinity+";

FirebaseAuth authFire = FirebaseAuth.instance;
a.User? userFire;
ThemeManager themeManager = ThemeManager();
