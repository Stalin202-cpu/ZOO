import 'package:flutter/material.dart';

// Home
import 'screens/home_screen.dart';

// Animales
import 'screens/animales/animal_list_screen.dart';
import 'screens/animales/animal_form_screen.dart';
import 'screens/animales/animal_detail_screen.dart';

// Especies
import 'screens/especies/especie_list_screen.dart';
import 'screens/especies/especie_form_screen.dart';

// Recintos
import 'screens/recintos/recinto_list_screen.dart';
import 'screens/recintos/recinto_form_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoológico App',

      // ✅ Ruta inicial
      initialRoute: '/',

      // ✅ Rutas combinadas (sin duplicar routes:)
      routes: {
        // Puedes escoger cuál pantalla quieres como inicio:
        // Si quieres Home:
        // '/': (context) => const HomeScreen(),

        // Si quieres que inicie en Animales:
        '/': (context) => const AnimalListScreen(),

        // HOME
        '/home': (context) => const HomeScreen(),

        // ANIMALES
        '/animal': (context) => const AnimalListScreen(),
        '/animal/form': (context) => const AnimalFormScreen(),
        '/animal/detail': (context) => const AnimalDetailScreen(),

        // ESPECIES
        '/especies': (context) => const EspecieScreen(),
        '/especieform': (context) => const EspecieForm(),

        // RECINTOS
        '/recintos': (context) => const RecintoScreen(),
        '/recintoform': (context) => const RecintoForm(),
      },
    );
  }
}
