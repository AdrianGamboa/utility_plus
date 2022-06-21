import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/category_db.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/models/category.dart';
import 'package:utility_plus/src/screens/list_page.dart';

import '../utils/alerts.dart';

late Future<List<Map<String, dynamic>>> _listCategory;
List<Category> listCategories = [];

class PlanningPage extends StatefulWidget {
  const PlanningPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PlanningPage> createState() => PlanningPageState();
}

class PlanningPageState extends State<PlanningPage> {
  bool nameExists = true;
  final newListTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ReRunnableFutureBuilder(
            future_: _listCategory, refreshCategories: getCategories),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: TextButton(
              onPressed: () {
                showNewListDialog();
              },
              child:
                  Row(children: const [Icon(Icons.add), Text('Nueva lista')])),
        ));
  }

  void showNewListDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      newListTextController.clear();
                    },
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () async {
                      insertCategory().then((value) {
                        nameExists = value;
                        if (_formKey.currentState!.validate()) {
                          getCategories();
                          Navigator.of(context).pop();
                          newListTextController.clear();
                        }
                      }).onError((error, stackTrace) => null);
                    },
                    child: const Text("Agregar lista"))
              ],
              content: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 380,
                  child: dialogContent()));
        });
  }

  Widget dialogContent() {
    return Form(
      key: _formKey,
      child: TextFormField(
          maxLength: 12,
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            if (newListTextController.text == '') {
              return 'Ingrese un nombre';
            } else if (nameExists == false) {
              return 'El nombre ya existe';
            }
            return null;
          },
          controller: newListTextController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Nombre de la lista",
          )),
    );
  }

  Future insertCategory() async {
    try {
      if (await CategoryDB.getByName(newListTextController.text) == null) {
        await CategoryDB.insert(
            Category(id: m.ObjectId(), name: newListTextController.text));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e == ("Internet error")) {
        showAlertDialog(context, 'Problema de conexión',
            'Comprueba si existe conexión a internet e inténtalo más tarde.');
      } else {
        showAlertDialog(context, 'Problema con el servidor',
            'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
      }
      setState(() {});
      return Future.error(e);
    }
  }

  getCategories() async {
    try {
      setState(() {
        _listCategory = CategoryDB.getByUserId();
      });

      //Convert the Future<List> of categories to a normal category list
      listCategories.clear();
      List categories = await _listCategory;
      for (var item in categories) {
        if (Category.fromMap(item).name != 'Agenda' &&
            Category.fromMap(item).name != 'Importante') {
          listCategories.add(Category.fromMap(item));
        }
      }
    } catch (e) {}
  }
}

class ReRunnableFutureBuilder extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> future_;
  final Function() refreshCategories;

  const ReRunnableFutureBuilder(
      {Key? key, required this.future_, required this.refreshCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future_,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return LinearProgressIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al extraer la información"));
          } else {
            return Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: categoryList(snapshot.data)),
                ),
              ),
            );
          }
        });
  }

  List<Widget> categoryList(data) {
    List<Widget> categories = [];

    for (var item in data) {
      categories.add(ListCard(
          category_: Category.fromMap(item),
          icon_: getIcon(Category.fromMap(item).name),
          refreshCategories: refreshCategories));
    }

    categories.insert(3, const Divider());
    return categories;
  }

  IconData getIcon(name) {
    if (name == 'To do') {
      return Icons.wb_sunny_outlined;
    } else if (name == 'Importante') {
      return Icons.label_important_outline;
    } else if (name == 'Agenda') {
      return Icons.calendar_month_outlined;
    }
    return Icons.list;
  }
}

bool isMainList(Category category) {
  if (category.name == 'To do' ||
      category.name == 'Importante' ||
      category.name == 'Agenda') {
    return true;
  }
  return false;
}

class ListCard extends StatefulWidget {
  final Category category_;
  final IconData icon_;
  final Function() refreshCategories;

  const ListCard(
      {Key? key,
      required this.category_,
      required this.icon_,
      required this.refreshCategories})
      : super(key: key);

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListPage(
                      category: widget.category_,
                      listCategory: listCategories)));
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(widget.icon_),
          const SizedBox(width: 10),
          Text(widget.category_.name,
              style: const TextStyle(
                fontSize: 16.0,
              )),
          const Spacer(),
          isMainList(widget.category_)
              ? const SizedBox()
              : SizedBox(
                  height: 30,
                  child: PopupMenuButton<String>(
                      tooltip: 'Opciones',
                      splashRadius: 24,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        popUpClick(value, context);
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Eliminar'}.map((String choice) {
                          return PopupMenuItem<String>(
                            height: 25,
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      }))
        ]));
  }

  Future<void> popUpClick(String value, context) async {
    switch (value) {
      case 'Eliminar':
        try {
          await CategoryDB.delete(widget.category_);
          widget.refreshCategories();
        } catch (e) {
          if (e == ("Internet error")) {
            showAlertDialog(context, 'Problema de conexión',
                'Comprueba si existe conexión a internet e inténtalo más tarde.');
          } else {
            showAlertDialog(context, 'Problema con el servidor',
                'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
          }
          setState(() {});
        }

        break;
    }
  }
}
