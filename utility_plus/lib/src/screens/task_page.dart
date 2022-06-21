import 'package:flutter/material.dart';
import 'package:utility_plus/src/database/task_db.dart';
import 'package:utility_plus/src/models/category.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import 'package:utility_plus/src/models/task.dart';

import '../utils/alerts.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    Key? key,
    required this.category,
    required this.listCategory_,
    required this.refreshTasks,
    this.taskInfo,
  }) : super(key: key);

  final Category category;
  final Function() refreshTasks;
  final List<Category> listCategory_;
  final Task? taskInfo;

  @override
  State<TaskPage> createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final reminderTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? date;
  TimeOfDay? time;
  late Category categoryChoosed;
  bool update = false;

  @override
  void initState() {
    super.initState();
    setCategory();

    initTaskInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                clearTxt();
              },
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (update) {
                    updateTask().then((value) {
                      widget.refreshTasks();
                      clearTxt();
                      Navigator.of(context).pop();
                    }).onError((error, stackTrace) => null);
                  } else {
                    insertTask().then((value) {
                      widget.refreshTasks();
                      clearTxt();
                      Navigator.of(context).pop();
                    }).onError((error, stackTrace) => null);
                  }
                }
              },
              child: const Text("Guardar"))
        ],
        content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
                padding: const EdgeInsets.all(10.0),
                width: 380,
                child: dialogContent())));
  }

  Widget dialogContent() {
    return Column(children: [
      const Text("Agregar tarea",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      const SizedBox(height: 20),
      Form(
          key: _formKey, child: textForm('Titulo', 1, 18, titleTextController)),
      const SizedBox(height: 20),
      textForm('Contenido', 2, null, contentTextController),
      const SizedBox(height: 20),
      datePicker(),
      const SizedBox(height: 20),
      dateTimePicker(),
      const SizedBox(height: 20),
      category()
    ]);
  }

  Future insertTask() async {
    try {
      final task = Task(
          id: m.ObjectId(),
          title: titleTextController.text,
          content: contentTextController.text,
          expirationDate: dateTextController.text,
          reminderDate: reminderTextController.text,
          important: categoryChoosed.name == 'Importante' ? true : false,
          categoryId: categoryChoosed.id);
      await TaskDB.insert(task);
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

  Future updateTask() async {
    try {
      final task = Task(
          id: widget.taskInfo!.id,
          title: titleTextController.text,
          content: contentTextController.text,
          expirationDate: dateTextController.text,
          reminderDate: reminderTextController.text,
          important: widget.taskInfo!.important,
          finished: widget.taskInfo!.finished,
          categoryId: categoryChoosed.id);
      await TaskDB.update(task);
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

  initTaskInfo() {
    if (widget.taskInfo != null) {
      titleTextController.text = widget.taskInfo!.title;
      contentTextController.text = widget.taskInfo!.content!;
      dateTextController.text = widget.taskInfo!.expirationDate!;
      reminderTextController.text = widget.taskInfo!.reminderDate!;
      categoryChoosed = findCategory();

      update = true;
    }
  }

  setCategory() {
    if (widget.category.name != 'Agenda' &&
        widget.category.name != 'Importante') {
      categoryChoosed = widget.category;
    } else {
      categoryChoosed = widget.listCategory_[0];
    }
  }

  Category findCategory() {
    var contain = widget.listCategory_
        .where((element) => element.id == widget.taskInfo!.categoryId);

    if (contain.isNotEmpty) {
      return contain.toList()[0];
    }
    return widget.category;
  }

  //WIDGETS
  Row category() {
    return Row(children: [
      const Text("Categoría", style: TextStyle(fontSize: 18)),
      const SizedBox(width: 20),
      Expanded(
          child: DropdownButtonFormField<Category>(
              hint: Text(categoryChoosed.name),
              isExpanded: true,
              onChanged: (newValue) {
                categoryChoosed = newValue!;
              },
              items: widget.listCategory_
                  .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value.name,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false)))
                  .toList()))
    ]);
  }

  Row dateTimePicker() {
    return Row(children: [
      Expanded(
          child: TextFormField(
              readOnly: true,
              controller: reminderTextController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    iconSize: 18,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      reminderTextController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                labelText: 'Recordatorio',
              ))),
      const SizedBox(width: 10),
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            pickDateTime(context);
          },
          icon: const Icon(Icons.add_alert_outlined))
    ]);
  }

  Row datePicker() {
    return Row(children: [
      Expanded(
          child: TextFormField(
              readOnly: true,
              controller: dateTextController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    iconSize: 18,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      dateTextController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                labelText: 'Fecha de vencimiento',
              ))),
      const SizedBox(width: 10),
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            pickDate(context).then((value) => dateTextController.text =
                '${date!.day}/${date!.month}/${date!.year}');
          },
          icon: const Icon(Icons.calendar_month))
    ]);
  }

  Widget textForm(name, lines, lenght, controller) {
    return SizedBox(
        width: 320,
        child: TextFormField(
            maxLength: lenght,
            maxLines: lines,
            minLines: 1,
            controller: controller,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (titleTextController.text == '') return 'Ingrese un título';
              return null;
            },
            decoration: InputDecoration(
              counterText: "",
              suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  iconSize: 18,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.clear();
                  },
                  icon: const Icon(Icons.clear)),
              labelText: name,
            )));
  }

  //SHOW DATE/HOUR PICKERS
  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 5));

    if (newDate == null) {
      return null;
    } else {
      date = newDate;
      return newDate;
    }
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialTime);

    if (newTime == null) {
      return null;
    } else {
      time = newTime;
      return newTime;
    }
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;
    if (!mounted) return;
    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');

      reminderTextController.text =
          '${date.day}/${date.month}/${date.year} $hours:$minutes';
    });
  }

  clearTxt() {
    FocusScope.of(context).requestFocus(FocusNode());
    titleTextController.clear();
    contentTextController.clear();
    dateTextController.clear();
    reminderTextController.clear();
    categoryChoosed = widget.category;
  }
}
