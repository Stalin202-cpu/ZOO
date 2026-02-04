import 'package:flutter/material.dart';

// Animales
import 'screens/animales/animal_detail_screen.dart';
import 'screens/animales/animal_form_screen.dart';
import 'screens/animales/animal_list_screen.dart';

// Historial
import 'screens/historial/historial_form_screen.dart';
import 'screens/historial/historial_list_screen.dart';
import 'screens/home_screen.dart';

//Especies
import 'screens/especies/especie_form_screen.dart';
import 'screens/especies/especie_list_screen.dart';

//Recintos
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

        // =========================
        // ESPECIES
        // =========================
        '/especies': (context) => const EspecieScreen(),
        '/especieform': (context) => const EspecieForm(),

        // =========================
        // RECINTOS
        // =========================
        '/recintos': (context) => const RecintoScreen(),
        '/recintoform': (context) => const RecintoForm(),

        // =========================
        // ANIMALES
        // =========================
        '/animales': (context) => const AnimalListScreen(),
        '/animalform': (context) => const AnimalFormScreen(),
        '/animaldetail': (context) => const AnimalDetailScreen(),

        // =========================
        // HISTORIAL MÉDICO
        // =========================
        '/historial': (context) => const HistorialListScreen(),
        '/historialform': (context) => const HistorialFormScreen(),
      },
    );
  }
}
