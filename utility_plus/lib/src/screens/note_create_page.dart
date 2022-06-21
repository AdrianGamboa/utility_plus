import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/database/note_db.dart';
import 'package:utility_plus/src/models/note.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:utility_plus/src/utils/connection.dart';
import 'package:utility_plus/src/utils/view_image_handler.dart';

import '../utils/alerts.dart';

class NoteCreate extends StatefulWidget {
  const NoteCreate({Key? key}) : super(key: key);

  @override
  State<NoteCreate> createState() => _NoteCreateState();
}

class _NoteCreateState extends State<NoteCreate> {
  /// Variables
  File? _imageFile;

  Color? _tempMainColor;
  Color? _tempShadeColor;
  Color? _mainColor = Colors.orange;
  Color? _shadeColor = Colors.orange[100];

  final _titleField = TextEditingController();
  final _contentField = TextEditingController();
  bool _pinButton = false;
  bool _loadindicador = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_loadindicador,
      child: IgnorePointer(
        ignoring: _loadindicador,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: _shadeColor,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: _mainColor,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.color_lens_outlined,
                    color: Colors.white,
                  ),
                  onPressed: _openColorPicker,
                ),
                IconButton(
                  icon: Icon(
                    Icons.push_pin_outlined,
                    color: _pinButton == true ? Colors.white : Colors.white30,
                  ),
                  onPressed: () {
                    // do something
                    if (_pinButton) {
                      _pinButton = false;
                    } else {
                      _pinButton = true;
                    }
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // do something
                    insertNote();
                  },
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _loadindicador
                      ? LinearProgressIndicator(
                          color: _mainColor, backgroundColor: _shadeColor)
                      : Container(
                          height: 4,
                        ),
                  TextField(
                    controller: _titleField,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'Título',
                        hintStyle: TextStyle(color: Colors.black38)),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: _mainColor,
                    thickness: 1,
                  ),
                  Expanded(
                    child: TextField(
                        controller: _contentField,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: 'Contenido',
                            hintStyle: TextStyle(color: Colors.black38)),
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        keyboardType: TextInputType.multiline),
                  ),
                  Divider(
                    color: _mainColor,
                    thickness: 1,
                  ),
                  Container(
                      child: _imageFile == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxHeight: 200, maxWidth: 330),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: ImageFullScreenWrapperWidget(
                                          dark: true,
                                          child: Image.file(_imageFile!),
                                        ))),
                                Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: _mainColor,
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () {
                                      // do something
                                      _imageFile = null;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            )),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // do something
                          _getFromGallery();
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // do something
                          _getFromCamera();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _tempShadeColor ??= Colors.white;
                _tempMainColor ??= _mainColor;

                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);

                _tempShadeColor = null;
                _tempMainColor = null;
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
        selectedColor: _shadeColor == Colors.white ? _mainColor : _shadeColor,
        onlyShadeSelection: true,
        onColorChange: (color) => setState(() => _tempShadeColor = color),
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      //maxWidth: 200,
      //maxHeight: 200,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      // maxWidth: 200,
      // maxHeight: 200,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadToFirebase(String pathName) async {
    if (_imageFile != null) {
      try {
        if (await hasNetwork()) {
          // Upload file and metadata to the path 'images/mountains.jpg'
          final uploadTask =
              FirebaseStorage.instance.ref().child('images/$pathName');

          await uploadTask.putFile(_imageFile!);
          String url = await uploadTask.getDownloadURL();
          return url;
        } else {
          throw ('Internet error');
        }
      } catch (e) {
        return Future.error(e);
      }
    }
    return null;
  }

  insertNote() async {
    if (_titleField.text.isEmpty &&
        _contentField.text.isEmpty &&
        _imageFile == null) {
      Navigator.of(context).pop();
    } else {
      try {
        _loadindicador = true;
        setState(() {});
        var id = m.ObjectId();

        final note = Note(
            id: id,
            uid: FirebaseAuth.instance.currentUser!.uid,
            title: _titleField.text,
            content: _contentField.text,
            pin: _pinButton,
            shadeColor: _shadeColor!.value,
            mainColor: _mainColor!.value,
            lastDate: DateTime.now(),
            image: await _uploadToFirebase(id.$oid));

        await NoteDB.insert(note);
        Navigator.of(context).pop();
      } catch (e) {
        _loadindicador = false;
        if (e == ("Internet error")) {
          showAlertDialog(context, 'Problema de conexión',
              'Comprueba si existe conexión a internet e inténtalo más tarde.');
        } else {
          showAlertDialog(context, 'Problema con el servidor',
              'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
        }
        setState(() {});
      }
    }
  }
}
