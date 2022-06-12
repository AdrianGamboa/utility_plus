import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:utility_plus/src/database/note_db.dart';
import 'package:utility_plus/src/models/note.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:utility_plus/src/utils/view_image_handler.dart';

class NoteView extends StatefulWidget {
  final dynamic recordNote;
  const NoteView({Key? key, required this.recordNote}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  /// Variables
  File? _imageFile;

  Color? _tempMainColor;
  Color? _tempShadeColor;
  Color? _mainColor;
  Color? _shadeColor;

  final _titleField = TextEditingController();
  final _contentField = TextEditingController();
  bool _pinButton = false;

  @override
  void initState() {
    _loadNote(widget.recordNote);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _shadeColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: _mainColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              onPressed: () => _deleteNote(widget.recordNote),
            ),
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
                _updateNote(widget.recordNote);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleField,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Título'),
              ),
              const Divider(
                thickness: 1,
              ),
              Expanded(
                child: TextField(
                    controller: _contentField,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Contenido'),
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    keyboardType: TextInputType.multiline),
              ),
              const Divider(
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
      //maxWidth: 200,
      //maxHeight: 200,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  _loadNote(var arg) {
    _titleField.text = arg['title'];
    _contentField.text = arg['content'];
    _pinButton = arg['pin'];
    _shadeColor = Color(arg['shadeColor']);
    _mainColor = Color(arg['mainColor']);
  }

  _mapNote(var arg) {
    return Note(
        id: arg['_id'],
        title: _titleField.text,
        content: _contentField.text,
        pin: _pinButton,
        shadeColor: _shadeColor!.value,
        mainColor: _mainColor!.value);
  }

  _updateNote(var arg) async {
    await NoteDB.update(_mapNote(arg));
    Navigator.of(context).pop();
  }

  _deleteNote(var arg) async {
    await NoteDB.delete(_mapNote(arg));
    Navigator.of(context).pop();
  }
}
