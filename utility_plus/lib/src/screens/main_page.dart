import 'package:flutter/material.dart';
import 'package:utility_plus/src/screens/finance_page.dart';
import 'package:utility_plus/src/services/AuthenticationServices.dart';
import 'package:utility_plus/src/screens/note_page.dart';
import 'package:utility_plus/src/screens/planning_page.dart';

import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  String pageName = 'Planificación';
  String focusIcon = 'icon1';
  //Pantallas de la barra de navegacion inferior
  NotePage notePage = const NotePage();
  PlanningPage planningPage = const PlanningPage();
  FinancePage financePage = const FinancePage();
  ProfilePage profilePage = const ProfilePage();

  late final AnimationController _controller4 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation4 = CurvedAnimation(
    parent: _controller4,
    curve: Curves.elasticOut,
  );

  late List<Widget> screens = [
    planningPage,
    notePage,
    financePage,
    profilePage
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
                  return {
                    'Perfil',
                    'Acerca de',
                    'Términos y Condiciones',
                    'Cerrar sesión'
                  }.map((String choice) {
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
              icon: focusIcon == 'icon1'
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => SlideTransition(
                        position: Tween(
                                begin: const Offset(-1, 0),
                                end: const Offset(0.0, 0.0))
                            .animate(anim),
                        child: child,
                      ),
                      child: const Icon(Icons.calendar_month,
                          key: ValueKey('icon1')),
                    )
                  : const AnimatedSwitcher(
                      duration: Duration(milliseconds: 0),
                      child: Icon(Icons.calendar_month_outlined,
                          key: ValueKey('icon2')),
                    ),
              label: 'Planificación'),
          //#2
          NavigationDestination(
              icon: focusIcon == 'icon2'
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => RotationTransition(
                        turns:
                            Tween<double>(begin: 0.0, end: 1.0).animate(anim),
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                      child: const Icon(Icons.note_alt, key: ValueKey('icon1')),
                    )
                  : const AnimatedSwitcher(
                      duration: Duration(milliseconds: 0),
                      child: Icon(Icons.note_alt_outlined,
                          key: ValueKey('icon2'))),
              label: 'Notas'),
          //#3
          NavigationDestination(
              icon: RotationTransition(
                turns: _animation4,
                child: const Icon(Icons.attach_money),
              ),
              label: 'Finanzas'),
          //#4
          NavigationDestination(
              icon: focusIcon == 'icon4'
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale:
                            Tween<double>(begin: 0.0, end: 1.0).animate(anim),
                        child: ScaleTransition(scale: anim, child: child),
                      ),
                      child: const Icon(Icons.person, key: ValueKey('icon1')),
                    )
                  : const AnimatedSwitcher(
                      duration: Duration(milliseconds: 0),
                      child:
                          Icon(Icons.person_outlined, key: ValueKey('icon2')),
                    ),
              label: 'Perfil'),
        ],
      ),
    );
  }

  void setIndex() {
    if (index == 0) {
      pageName = 'Planificación';
      focusIcon = 'icon1';
    } else if (index == 1) {
      pageName = 'Notas';
      focusIcon = 'icon2';
    } else if (index == 2) {
      pageName = 'Finanzas';
      focusIcon = 'icon3';
      _controller4.forward().then((value) => _controller4.reset());
    } else if (index == 3) {
      pageName = 'Perfil';
      focusIcon = 'icon4';
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Perfil':
        index = 3;
        pageName = 'Perfil';
        focusIcon = 'icon4';
        setState(() {});
        break;
      case 'Acerca de':
        Navigator.of(context).pushNamed('/about');
        break;
      case 'Términos y Condiciones':
        Navigator.of(context).pushNamed('/conditionsterms');
        break;
      case 'Cerrar sesión':
        AuthenticationService()
            .signOut(context)
            .then(
                (value) => Navigator.of(context).pushReplacementNamed('/login'))
            .onError((error, stackTrace) => setState(() {}));
        break;
    }
  }
}
