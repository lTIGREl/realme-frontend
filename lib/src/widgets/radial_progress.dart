// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_required_positional_param, prefer_typing_uninitialized_variables

import 'dart:math';
import 'package:flutter/material.dart';

class RadialProgress extends StatefulWidget {
  final Widget child;
  final porcentaje;
  final Color colorPrimario;
  final Color colorSecundario;

  RadialProgress(
      {required this.porcentaje,
      this.colorPrimario = Colors.red,
      this.colorSecundario = Colors.grey,
      required this.child});

  @override
  State<RadialProgress> createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late double porcentajeAnterior;
  late Widget wChild;

  @override
  void initState() {
    porcentajeAnterior = widget.porcentaje;
    wChild = widget.child;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward(from: 0.0);
    final diferenciaAnimar = widget.porcentaje - porcentajeAnterior;
    porcentajeAnterior = widget.porcentaje;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: _MiRadialProgress(
                (widget.porcentaje -
                    diferenciaAnimar +
                    (diferenciaAnimar * controller.value)),
                widget.colorPrimario,
                widget.colorSecundario),
            child: child,
          ),
        );
      },
      child: wChild,
    );
  }
}

class _MiRadialProgress extends CustomPainter {
  final porcentaje;
  final Color colorPrimario;
  final Color colorSecundario;
  _MiRadialProgress(@required this.porcentaje, @required this.colorPrimario,
      @required this.colorSecundario);
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(center: Offset(0, 0), radius: 180);
    final Gradient gradiente = LinearGradient(
        colors: [Color(0xffc02ff), Color(0xff6d05e8), this.colorPrimario]);
    final paint = Paint()
      ..strokeWidth = 4
      ..color = colorSecundario
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radio = min(size.width * 0.5, size.height * 0.5);

    canvas.drawCircle(center, radio, paint);

    //arco

    final paintArco = Paint()
      ..strokeWidth = 10
      //..color = colorPrimario
      ..shader = gradiente.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    //parte que se va a ir llenando
    double arcAngle = 2 * pi * porcentaje / 100;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radio), -pi / 2,
        arcAngle, false, paintArco);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
