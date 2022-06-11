import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/mongodatabase.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}
