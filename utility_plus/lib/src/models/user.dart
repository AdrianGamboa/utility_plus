import 'package:mongo_dart/mongo_dart.dart';

class User {
  final ObjectId id;
  final String nombre;
  final String primerApellido;
  final String segundoApellido;
  final String email;
  
  final String uid;

  User({required this.id, required this.nombre, required this.primerApellido, required this.segundoApellido, required this.email, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'nombre': nombre,
      'primerApellido': primerApellido,
      'segundoApellido': segundoApellido,
      'email': email,
      'uid': uid,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : nombre = map['nombre'],
        id = map['_id'],
        primerApellido = map['primerApellido'],
        segundoApellido = map['segundoApellido'],
        email = map['email'],
        uid = map['uid'];
}