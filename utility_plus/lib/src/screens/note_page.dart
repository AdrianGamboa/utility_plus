import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotePage extends StatefulWidget {
  const NotePage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotePage> createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notas"), elevation: 0.0),
      body: buildNotes(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/notedetail');
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  var d = [
    'hola',
    'hola como esta espero que muy bien soy mencho wey.hola como esta espero que muy bien soy mencho wey.hola como esta espero que muy bien soy mencho wey.',
    'hola como esta espero que muy bien soy mencho wey.',
    'hola',
  ];
  Widget buildNotes() => MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        padding: const EdgeInsets.all(10.0),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
              //padding: const EdgeInsets.all(14.0),
              child: Card(
            color: Colors.grey[400],
            child: Column(
              children: [
                Text('Titulo'),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'index: $index\n${d[index]}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 12,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'fecha de creación',
                ),
              ],
            ),
          ));
        },
      );
}
