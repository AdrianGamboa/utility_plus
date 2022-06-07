import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  /// Variables
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.push_pin_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: 'Título'),
            ),
            const Divider(
              thickness: 1,
            ),
            const Expanded(
              child: TextField(
                  decoration: InputDecoration(
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
                child: imageFile == null
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: 200, maxWidth: 200),
                            child: FullScreenWidget(
                              child: Hero(
                                tag: "customTag",
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // do something
                              imageFile = null;
                              setState(() {});
                            },
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
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.photo_size_select_actual_outlined),
      //       label: 'Galería',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.camera_alt_outlined),
      //       label: 'Camara',
      //     ),
      //   ],
      //   selectedItemColor: Colors.amber[800],
      // ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      //maxWidth: 200,
      //maxHeight: 200,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 200,
      maxHeight: 200,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
