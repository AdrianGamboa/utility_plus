import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/task_db.dart';
import 'package:utility_plus/src/models/category.dart';
import 'package:utility_plus/src/models/task.dart';
import 'package:utility_plus/src/screens/task_page.dart';

late Future<List<Map<String, dynamic>>> _listTask;
List<Task> _listTasks = [];

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.category, required this.listCategory})
      : super(key: key);

  final Category category;
  final List<Category> listCategory;

  @override
  State<ListPage> createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    _listTasks.clear();
    getTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: AppBar(
              title: Text(widget.category.name),
            )),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(children: [
              ReRunnableFutureBuilder(
                  future_: _listTask, refreshTasks: getTasks, task: taskCard)
            ]))),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return TaskPage(
                        category: widget.category,
                        listCategory_: widget.listCategory,
                        refreshTasks: getTasks);
                  });
            }));
  }

  getTasks() {
    setState(() {
      if (widget.category.name == 'Importante') {
        _listTask = TaskDB.getByImportance();
      } else if (widget.category.name == 'Agenda') {
        _listTask = TaskDB.getByUserId();
      } else {
        _listTask = TaskDB.getByCategoryId(widget.category.id);
      }
    });
  }

  Widget taskCard(int pos) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return TaskPage(
                    category: widget.category,
                    listCategory_: widget.listCategory,
                    taskInfo: _listTasks[pos],
                    refreshTasks: getTasks);
              });
        },
        child: Row(children: [
          Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.blue,
              value: _listTasks[pos].finished,
              onChanged: (value) {
                setState(() {
                  _listTasks[pos].finished = value!;
                });
                update(_listTasks[pos], widget.category);
              }),
          const SizedBox(width: 10),
          RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                _listTasks[pos].important
                    ? WidgetSpan(
                        child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            child: const Icon(Icons.label_important, size: 18)))
                    : const TextSpan(),
                TextSpan(
                    text: '${_listTasks[pos].title}\n',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: _listTasks[pos].finished!
                            ? TextDecoration.lineThrough
                            : null)),
                TextSpan(
                    text: _listTasks[pos].expirationDate,
                    style: const TextStyle(height: 1.5))
              ])),
          const Spacer(),
          SizedBox(
              height: 30,
              child: PopupMenuButton<String?>(
                  tooltip: 'Opciones',
                  splashRadius: 24,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    popUpClick(value!, _listTasks[pos]);
                  },
                  itemBuilder: (BuildContext context) {
                    return {
                      'Eliminar',
                      _listTasks[pos].important
                          ? 'Desmarcar como importante'
                          : 'Marcar como importante'
                    }.map((String choice) {
                      return choice == ''
                          ? const PopupMenuItem<String>(height: 0, child: null)
                          : PopupMenuItem<String>(
                              height: 25,
                              value: choice,
                              child: Text(choice),
                            );
                    }).toList();
                  }))
        ]));
  }

  void popUpClick(String value, Task task_) {
    if (value == 'Marcar como importante' ||
        value == 'Desmarcar como importante') {
      setState(() {
        task_.important = !task_.important;
      });
      update(task_, widget.category);
    } else if (value == 'Eliminar') {
      _listTasks.removeWhere((item) => item.id == task_.id);
      delete(task_).then((value) => getTasks());
    }
  }

  Future update(task_, category_) async {
    await TaskDB.update(task_);
  }

  Future delete(task_) async {
    await TaskDB.delete(task_);
  }
}

class ReRunnableFutureBuilder extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> future_;
  final Function() refreshTasks;
  final Function task;

  const ReRunnableFutureBuilder(
      {Key? key,
      required this.future_,
      required this.refreshTasks,
      required this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future_,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return const Center(
                child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Error al extraer la información")));
          } else {
            return Column(children: taskList(snapshot.data, context));
          }
        });
  }

  List<Widget> taskList(data, context) {
    List<Widget> tasks = [];
    bool band = false;

    if (!data.isEmpty) {
      int pos = 0;
      if (data.length > _listTasks.length || _listTasks.isEmpty) {
        _listTasks.clear();
        band = true;
      } else if (data.length <= _listTasks.length && dataChanged(data)) {
        _listTasks.clear();
        band = true;
      }

      for (var item in data) {
        if (band == true) {
          _listTasks.add(Task.fromMap(item));
        }
        tasks.add(task(pos));
        pos = pos + 1;
      }
    } else {
      tasks.add(const Center(
          child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('No hay tareas en esta lista.'))));
    }
    return tasks;
  }

  bool dataChanged(data) {
    int cont = 0;

    for (var item in data) {
      if (_listTasks[cont].title != Task.fromMap(item).title ||
          _listTasks[cont].content != Task.fromMap(item).content ||
          _listTasks[cont].expirationDate !=
              Task.fromMap(item).expirationDate ||
          _listTasks[cont].reminderDate != Task.fromMap(item).reminderDate ||
          _listTasks[cont].categoryId != Task.fromMap(item).categoryId) {
        return true;
      }
      cont++;
    }

    return false;
  }
}
