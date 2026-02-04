import 'package:flutter/material.dart';


// para hacer pruevas rápidas

// mis rutas para animlaes
import 'screens/animales/animal_list_screen.dart';
import 'screens/animales/animal_form_screen.dart';
import 'screens/animales/animal_detail_screen.dart';

//  rutas para especies

//  rutas para recintos

//  rutas para historial medico




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoológico App',

      // ruta inicial
      initialRoute: '/',

      // rutas de la aplicación
      routes: {
        
        '/': (context) => AnimalListScreen(),

        // ANIMALES
        '/animal': (context) => const AnimalListScreen(),
        '/animal/form': (context) => const AnimalFormScreen(),
        '/animal/detail': (context) => const AnimalDetailScreen(),
      },
    );
  }
}
