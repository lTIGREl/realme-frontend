// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/pages/clients_page.dart';
import 'package:real_me_fitness_center/src/pages/routine_page.dart';
import 'package:real_me_fitness_center/src/pages/sales_page.dart';
import 'package:real_me_fitness_center/src/providers/main_menu.dart';
import 'package:real_me_fitness_center/src/providers/routine.dart';
import 'package:real_me_fitness_center/src/providers/sales_add.dart';
import 'package:real_me_fitness_center/src/providers/search.dart';

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedPageModel(),
      child: Scaffold(
        body: Center(
          child: Builder(builder: (context) {
            int actualPage = Provider.of<SelectedPageModel>(context).page;
            return _ActualPage(actualPage);
          }),
        ),
        bottomNavigationBar: _NavigationBarMainMenu(),
      ),
    );
  }

  Widget _ActualPage(int actualPage) {
    Widget pagina;
    switch (actualPage) {
      case 0:
        pagina = ChangeNotifierProvider.value(
            value: RoutineProvider(), child: RoutinePage());
        break;
      case 1:
        pagina = ChangeNotifierProvider.value(
            value: SearchOption(), child: ClientsPage());
        break;
      case 2:
        pagina = ChangeNotifierProvider(
            create: (context) => SelectedItemSale(), child: SalesPage());
        break;
      default:
        pagina = Container();
    }
    return pagina;
  }
}

class _NavigationBarMainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int index = Provider.of<SelectedPageModel>(context).page;
    return BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          Provider.of<SelectedPageModel>(context, listen: false).page = value;
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Rutina'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Membresías'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'Ventas')
        ]);
  }
}
