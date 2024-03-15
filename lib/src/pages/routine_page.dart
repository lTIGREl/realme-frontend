// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/models/routine.dart';
import 'package:real_me_fitness_center/src/providers/routine.dart';

import '../widgets/slideshow.dart';

class RoutinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoutinePageBase();
  }
}

class RoutinePageBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, String>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var datos = snapshot.data!;
          List<Routine> routines =
              datos.map((item) => Routine(data: item)).toList();
          List<DailyCard> dailyCards = routines
              .map((routine) => DailyCard(
                  routine: routine, svgpicture: 'assets/${routine.day}.svg'))
              .toList();
          return Slideshow(
              bulletPrimario: 17,
              bulletSecundario: 10,
              puntosArriba: true,
              slides: dailyCards);
        }
      },
      future: Provider.of<RoutineProvider>(context).getRoutine(),
    );
  }
}

class DailyCard extends StatelessWidget {
  final Routine routine;
  final String svgpicture;
  final double widthPic;

  const DailyCard(
      {required this.svgpicture, required this.routine, this.widthPic = 250});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 10,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: SvgPicture.asset(
                svgpicture,
                width: widthPic,
              ),
            ),
            Text(routineDay(routine.day), style: TextStyle(fontSize: 50)),
            Text(routine.main),
            (routine.complementary.isNotEmpty)
                ? Text(routine.complementary)
                : SizedBox(),
            routine.cardio.isNotEmpty ? Text(routine.cardio) : SizedBox(),
            ElevatedButton(
              onPressed: () => openDialog(context),
              child: Text('Editar'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fixedSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }

  void openDialog(BuildContext context) {
    TextEditingController mainCtrl = TextEditingController();
    mainCtrl.text = routine.main;
    TextEditingController compCtrl = TextEditingController();
    compCtrl.text = routine.complementary;
    TextEditingController cardioCtrl = TextEditingController();
    cardioCtrl.text = routine.cardio;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(routine.day),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                      controller: mainCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Principal'),
                      ),
                      maxLines: null),
                  TextFormField(
                      controller: compCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Complementario'),
                      ),
                      maxLines: null),
                  TextFormField(
                      controller: cardioCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Cardio'),
                      ),
                      maxLines: null)
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                routine.main = mainCtrl.text;
                routine.complementary = compCtrl.text;
                routine.cardio = cardioCtrl.text;
                Routine objRoutine = Routine(data: {
                  'id': routine.id,
                  'day': routine.day,
                  'main': routine.main,
                  'complementary': routine.complementary,
                  'cardio': routine.cardio
                });
                bool isCorrect = await objRoutine.postRoutines();
                isCorrect ? Navigator.pop(context) : null;
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  String routineDay(String day) {
    switch (day) {
      case 'Monday':
        return 'Lunes';
      case 'Tuesday':
        return 'Martes';
      case 'Wednesday':
        return 'Miércoles';
      case 'Thursday':
        return 'Jueves';
      case 'Friday':
        return 'Viernes';
      default:
        return '';
    }
  }
}
