import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/especies/especie_form_screen.dart';
import 'screens/especies/especie_list_screen.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: {
        '/': (context) => HomeScreen(),
        '/especies': (context) => EspecieScreen(),
        '/especieform': (context) => EspecieForm(),
    
      },
    );
  }
}
