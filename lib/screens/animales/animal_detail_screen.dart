import 'package:flutter/material.dart';
import '../../models/animal_model.dart';

class AnimalDetailScreen extends StatelessWidget {
  const AnimalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AnimalModel animal =
        ModalRoute.of(context)!.settings.arguments as AnimalModel;

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Animal")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre: ${animal.nombre}"),
            Text("Sexo: ${animal.sexo}"),
            Text("Fecha nacimiento: ${animal.fechaNacimiento}"),
            Text("Estado salud: ${animal.estadoSalud}"),
            const SizedBox(height: 10),
            Text("Especie: ${animal.especieNombre}"),
            Text("Recinto: ${animal.recintoNombre}"),
          ],
        ),
      ),
    );
  }
}
