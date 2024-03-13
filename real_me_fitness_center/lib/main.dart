import 'package:flutter/material.dart';
import 'package:real_me_fitness_center/src/pages/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'Real Me', home: LogInPage());
  }
}
