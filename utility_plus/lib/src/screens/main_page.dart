import 'package:flutter/material.dart';
import 'package:utility_plus/src/services/AuthenticationServices.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  String pageName = 'Planificación';
  //Controladores de animación
  int _controller1 = 1;
  int _controller2 = 0;
  int _controller3 = 0;
  late final AnimationController _controller4 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation4 = CurvedAnimation(
    parent: _controller4,
    curve: Curves.elasticOut,
  );

  final screens = [
    const Center(child: Text('Planificación')),
    const Center(child: Text('Notas')),
    const Center(child: Text('Recordatorios')),
    const Center(child: Text('Finanzas')),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller4.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: Text(pageName),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Perfil', 'Ajustes', 'Acerca de', 'Cerrar sesión'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          )),
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        height: 50,
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (index) {
          if (this.index != index) {
            setState(() {
              this.index = index;
              setIndex();
            });
          }
        },
        destinations: [
          //#1
          NavigationDestination(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 2.0).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: _controller1 == 0
                    ? const Icon(Icons.calendar_month_outlined,
                        key: ValueKey('icon1'))
                    : const Icon(Icons.calendar_month, key: ValueKey('icon2')),
              ),
              label: 'Planificación'),
          //#2
          NavigationDestination(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 2.0).animate(anim),
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: _controller2 == 0
                    ? const Icon(Icons.note_alt_outlined,
                        key: ValueKey('icon1'))
                    : const Icon(Icons.note_alt, key: ValueKey('icon2')),
              ),
              label: 'Notas'),
          //#3
          NavigationDestination(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 2.0).animate(anim),
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: _controller3 == 0
                    ? const Icon(Icons.pending_actions, key: ValueKey('icon1'))
                    : const Icon(Icons.pending_actions_outlined,
                        key: ValueKey('icon2')),
              ),
              label: 'Recordatorios'),
          //#4
          NavigationDestination(
              icon: RotationTransition(
                turns: _animation4,
                child: const Icon(Icons.attach_money),
              ),
              label: 'Finanzas'),
        ],
      ),
    );
  }

  void setIndex() {
    if (index == 0) {
      pageName = 'Planificación';
      _controller1 = _controller1 == 0 ? 1 : 0;
    } else if (index == 1) {
      pageName = 'Notas';
      _controller2 = _controller2 == 0 ? 1 : 0;
    } else if (index == 2) {
      pageName = 'Recordatorios';
      _controller3 = _controller3 == 0 ? 1 : 0;
    } else if (index == 3) {
      pageName = 'Finanzas';
      _controller4.forward().then((value) => _controller4.reset());
    }
    resetIndex();
  }

  void resetIndex() {
    if (_controller1 == 1 && index != 0) _controller1 = 0;
    if (_controller2 == 1 && index != 1) _controller2 = 0;
    if (_controller3 == 1 && index != 2) _controller3 = 0;
  }

  void handleClick(String value) {
    switch (value) {
      case 'Perfil':
        break;
      case 'Ajustes':
        break;
      case 'Acerca de':
        Navigator.of(context).pushNamed('/about');
        break;
      case 'Cerrar sesión':
        AuthenticationService().signOut(context);
        break;
    }
  }
}
