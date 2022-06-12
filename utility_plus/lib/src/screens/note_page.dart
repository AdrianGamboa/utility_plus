import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:utility_plus/src/database/note_db.dart';
import 'package:utility_plus/src/screens/note_view_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotePage> createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  List notesList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: NoteDB.getDocuments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                // Return error
                return const Text('error');
              } else {
                notesList = snapshot.data as List;

                return buildNotes();
                // Return Listview with documents data
              }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/notecreate')
              .then((value) => setState(() {}));
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget buildNotes() => MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        padding: const EdgeInsets.all(10.0),
        itemCount: notesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteView(recordNote: notesList[index]),
              ),
            ).then((value) => setState(() {})),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Card(
                  color: Color(notesList[index]['shadeColor']) == Colors.white
                      ? Color(notesList[index]['mainColor'])
                      : Color(notesList[index]['shadeColor']),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 30, top: 10),
                        child: Text(notesList[index]['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          notesList[index]['content'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'fecha de creación',
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 8,
                  child: notesList[index]['pin'] == true
                      ? const Icon(
                          Icons.push_pin,
                          color: Colors.white70,
                        )
                      : Container(),
                )
              ],
            ),
          );
        },
      );
}
