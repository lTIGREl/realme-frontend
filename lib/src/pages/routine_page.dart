// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/models/routine.dart';
import 'package:real_me_fitness_center/src/pages/login_page.dart';
import 'package:real_me_fitness_center/src/providers/routine.dart';
import 'package:real_me_fitness_center/src/sharedPrefs/loginToken.dart';

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
    return SafeArea(
      child: FutureBuilder(
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
            return Stack(
              children: [
                CreditsButton(),
                Slideshow(
                    bulletPrimario: 17,
                    bulletSecundario: 10,
                    puntosArriba: true,
                    slides: dailyCards),
              ],
            );
          }
        },
        future: Provider.of<RoutineProvider>(context).getRoutine(),
      ),
    );
  }
}

class CreditsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Positioned(
        right: 0,
        child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        content: SizedBox(
                            height: height * 0.3,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.person, size: width * 0.1),
                                        SizedBox(
                                            width: width * 0.5,
                                            child: Text(
                                                'Aplicación desarrollada por Ing. Fernando Tigre',
                                                softWrap: true))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.email, size: width * 0.1),
                                        SizedBox(
                                            width: width * 0.5,
                                            child: Text(
                                                'E-Mail: joefernando20899@gmail.com'))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.whatsapp, size: width * 0.1),
                                        SizedBox(
                                            width: width * 0.5,
                                            child: Text('Contacto: 0979851249'))
                                      ]),
                                  SizedBox(
                                      width: width * 0.4,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await LoginToken.removeToken();
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                'login',
                                                (route) => false);
                                          },
                                          child: Row(children: [
                                            Icon(Icons.arrow_back),
                                            Text('Cerrar sesión')
                                          ])))
                                ])));
                  });
            },
            icon: Icon(Icons.help)));
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
        return EditDialogRoutine(
            routine: routine,
            mainCtrl: mainCtrl,
            compCtrl: compCtrl,
            cardioCtrl: cardioCtrl);
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

class EditDialogRoutine extends StatefulWidget {
  const EditDialogRoutine({
    Key? key,
    required this.routine,
    required this.mainCtrl,
    required this.compCtrl,
    required this.cardioCtrl,
  }) : super(key: key);

  final Routine routine;
  final TextEditingController mainCtrl;
  final TextEditingController compCtrl;
  final TextEditingController cardioCtrl;

  @override
  State<EditDialogRoutine> createState() => _EditDialogRoutineState();
}

class _EditDialogRoutineState extends State<EditDialogRoutine> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          title: Text(widget.routine.day),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                      controller: widget.mainCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Principal'),
                      ),
                      maxLines: null),
                  TextFormField(
                      controller: widget.compCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Complementario'),
                      ),
                      maxLines: null),
                  TextFormField(
                      controller: widget.cardioCtrl,
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
                widget.routine.main = widget.mainCtrl.text;
                widget.routine.complementary = widget.compCtrl.text;
                widget.routine.cardio = widget.cardioCtrl.text;
                Routine objRoutine = Routine(data: {
                  'id': widget.routine.id,
                  'day': widget.routine.day,
                  'main': widget.routine.main,
                  'complementary': widget.routine.complementary,
                  'cardio': widget.routine.cardio
                });
                setState(() => _isLoading = true);
                bool isCorrect = await objRoutine.postRoutines();
                isCorrect
                    ? Navigator.pop(context)
                    : setState(() {
                        _isLoading = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text('Ocurrió un error')));
                      });
              },
              child: Text('Guardar'),
            ),
          ],
        ),
        if (_isLoading)
          Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()))
      ],
    );
  }
}
