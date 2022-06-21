import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utility_plus/src/utils/global.dart';
import '../database/category_db.dart';
import '../models/category.dart';
import '../services/AuthenticationServices.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

import '../utils/alerts.dart';

String auxpass = '';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthenticationService _auth = AuthenticationService();
  late String nombre;
  late String primerApellido;
  late String segundoApellido;
  late String email;
  late String password;
  late String passwordVerificado;
  bool valuefirst = false;
  bool banderaDialogo = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: themeManager.themeMode == ThemeMode.light
                          ? Image.asset("assets/images/UtilityC.png",
                              width: 120)
                          : Image.asset("assets/images/UtilityO.png",
                              width: 120),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Nombre:",
                        ),
                        onChanged: (value) {
                          nombre = value;
                        },
                        onSaved: (value) {
                          nombre = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          if (RegExp(r'(^(?![\s.]+$)[a-zA-Z\u00C0-\u00FF\s.]*$)')
                                  .hasMatch(value.trim()) ==
                              false) {
                            return "El nombre únicamente debe tener caracteres alfabéticos";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Primer apellido:",
                        ),
                        onSaved: (value) {
                          primerApellido = value!;
                        },
                        onChanged: (value) {
                          primerApellido = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          if (RegExp(r'(^(?![\s.]+$)[a-zA-Z\u00C0-\u00FF\s.]*$)')
                                  .hasMatch(value.trim()) ==
                              false) {
                            return "El apellido únicamente debe tener caracteres alfabéticos";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Segundo apellido:",
                        ),
                        onSaved: (value) {
                          segundoApellido = value!;
                        },
                        onChanged: (value) {
                          segundoApellido = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          if (RegExp(r'(^(?![\s.]+$)[a-zA-Z\u00C0-\u00FF\s.]*$)')
                                  .hasMatch(value.trim()) ==
                              false) {
                            return "El apellido únicamente debe tener caracteres alfabéticos";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email:",
                        ),
                        onSaved: (value) {
                          email = value!;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value.trim()) ==
                              false) {
                            return "La dirección de correo electronico debe ser válida";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(16)],
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password:",
                        ),
                        onSaved: (value) {
                          password = value!;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          auxpass = value!;
                          if (value.isEmpty) {
                            return "Llene este campo";
                          } else if (value.trim().length < 8 ||
                              value.trim().length > 16) {
                            return "La contraseña debe tener entre 8 y 16 caracteres";
                          } else if (RegExp(r'(?=.*?[a-z])')
                                  .hasMatch(value.trim()) ==
                              false) {
                            return "La contraseña debe contener caracteres alfabéticos";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(16)],
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Verifica tu password:",
                        ),
                        onSaved: (value) {
                          passwordVerificado = value!;
                        },
                        onChanged: (value) {
                          passwordVerificado = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          if (value != auxpass) {
                            return "Las contraseñas no coinciden";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CheckBoxFormField(),
                        Text.rich(
                          TextSpan(
                            text: "Aceptar ",
                            children: [
                              TextSpan(
                                  text: "términos y condiciones",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 290,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createUser();
                            //Se puede mandar mensaje de te has logueado correctamente o un circulo cargando
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        child: const Text("Registrate"),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text.rich(TextSpan(
                        text: '¿Ya tienes cuenta?',
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Iniciar sesión',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                          )
                        ])),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createUser() async {
    try {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      dynamic result = await _auth.createNewUser(
          nombre.trim(),
          primerApellido.trim(),
          segundoApellido.trim(),
          email.trim(),
          password.trim(),
          context);
      if (result == null) {
        throw ('Email is not valid');
      } else {
        //print(result.toString());

        //Inserta las listas por defecto del usuario
        await CategoryDB.insert(Category(id: m.ObjectId(), name: 'To do'));
        await CategoryDB.insert(Category(id: m.ObjectId(), name: 'Importante'));
        await CategoryDB.insert(Category(id: m.ObjectId(), name: 'Agenda'));
        // ignore: use_build_context_synchronously
        Navigator.of(context).popUntil((route) => route.isFirst);
        //Valida si el usuario esta logueado
        if (userFire == null) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          // ignore: prefer_interpolation_to_compose_strings, avoid_print
          print("Ingreso: " + userFire!.uid.toString());
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacementNamed('/main');
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else if (e == ('Email is not valid')) {
        showAlertDialog(context, 'Problema de datos',
            'El correo electrónico proporcionado es inválido.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
    }
  }
}

class CheckBoxFormField extends StatefulWidget {
  const CheckBoxFormField({Key? key}) : super(key: key);

  @override
  State<CheckBoxFormField> createState() => _CheckBoxFormFieldState();
}

class _CheckBoxFormFieldState extends State<CheckBoxFormField> {
  bool checkboxValue = false;
  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (state) {
        return Column(
          children: [
            Checkbox(
              value: checkboxValue,
              checkColor: Colors.white,
              activeColor: Colors.greenAccent,
              onChanged: (value) {
                checkboxValue = value!;
                state.didChange(value);
              },
            ),
            Text(state.errorText ?? '',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                )),
          ],
        );
      },
      validator: (value) {
        if (!checkboxValue) {
          return 'Debes aceptar \n los términos';
        }
        return null;
      },
    );
  }
}
