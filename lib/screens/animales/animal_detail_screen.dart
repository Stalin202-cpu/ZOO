import 'package:flutter/material.dart';

import '../../models/animal_model.dart';

class AnimalDetailScreen extends StatefulWidget {
  const AnimalDetailScreen({super.key});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  AnimalModel? animal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Capturar parámetros desde la pantalla anterior
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      animal = args as AnimalModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (animal == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalle del Animal"),
        ),
        body: const Center(
          child: Text("No se recibió información del animal"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Animal"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal!.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                Text("Sexo: ${animal!.sexo}"),
                const SizedBox(height: 8),

                Text("Fecha de nacimiento: ${animal!.fechaNacimiento}"),
                const SizedBox(height: 8),

                Text("Estado de salud: ${animal!.estadoSalud}"),
                const SizedBox(height: 8),

                Text("ID Especie: ${animal!.idEspecie}"),
                const SizedBox(height: 8),

                Text("ID Recinto: ${animal!.idRecinto}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
