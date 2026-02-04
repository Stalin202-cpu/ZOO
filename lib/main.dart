import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

import 'screens/especies/especie_form_screen.dart';
import 'screens/especies/especie_list_screen.dart';

import 'screens/recintos/recinto_form_screen.dart';
import 'screens/recintos/recinto_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: {
        '/': (context) => const HomeScreen(),

        '/especies': (context) => const EspecieScreen(),
        '/especieform': (context) => const EspecieForm(),

        '/recintos': (context) => const RecintoScreen(),
        '/recintoform': (context) => const RecintoForm(),
      },
    );
  }
}
