import 'package:flutter/material.dart';

import '../../models/historial_model.dart';
import '../../models/animal_model.dart';

import '../../repositories/historial_repository.dart';
import '../../repositories/animal_repository.dart';

class HistorialFormScreen extends StatefulWidget {
  const HistorialFormScreen({super.key});

  @override
  State<HistorialFormScreen> createState() => _HistorialFormScreenState();
}

class _HistorialFormScreenState extends State<HistorialFormScreen> {
  final formKey = GlobalKey<FormState>();

  final fechaController = TextEditingController();
  final diagnosticoController = TextEditingController();
  final tratamientoController = TextEditingController();
  final observacionesController = TextEditingController();

  final animalRepo = AnimalRepository();
  final historialRepo = HistorialRepository();

  List<AnimalModel> animales = [];
  int? idAnimalSeleccionado;

  HistorialModel? historial;
  bool cargando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is HistorialModel) {
      historial = args;

      fechaController.text = historial!.fecha;
      diagnosticoController.text = historial!.diagnostico;
      tratamientoController.text = historial!.tratamiento;
      observacionesController.text = historial!.observaciones ?? '';

      idAnimalSeleccionado = historial!.idAnimal;
    }

    cargarAnimales();
  }

  Future<void> cargarAnimales() async {
    animales = await animalRepo.getAll();
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = historial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEditar ? "Editar historial médico" : "Registrar historial médico",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: formKey,
                child: ListView(
                  children: [
                    // =========================
                    // ANIMAL
                    // =========================
                    DropdownButtonFormField<int>(
                      value: idAnimalSeleccionado,
                      items: animales
                          .map(
                            (a) => DropdownMenuItem(
                              value: a.idAnimal,
                              child: Text(a.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => idAnimalSeleccionado = v);
                      },
                      validator: (v) =>
                          v == null ? "Seleccione un animal" : null,
                      decoration: const InputDecoration(
                        labelText: "Animal",
                        prefixIcon: Icon(Icons.pets),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // FECHA
                    // =========================
                    TextFormField(
                      controller: fechaController,
                      validator: (v) => v == null || v.isEmpty
                          ? "La fecha es requerida"
                          : null,
                      decoration: const InputDecoration(
                        labelText: "Fecha",
                        prefixIcon: Icon(Icons.date_range),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // DIAGNOSTICO
                    // =========================
                    TextFormField(
                      controller: diagnosticoController,
                      validator: (v) => v == null || v.isEmpty
                          ? "Diagnóstico requerido"
                          : null,
                      decoration: const InputDecoration(
                        labelText: "Diagnóstico",
                        prefixIcon: Icon(Icons.medical_information),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // TRATAMIENTO
                    // =========================
                    TextFormField(
                      controller: tratamientoController,
                      validator: (v) => v == null || v.isEmpty
                          ? "Tratamiento requerido"
                          : null,
                      decoration: const InputDecoration(
                        labelText: "Tratamiento",
                        prefixIcon: Icon(Icons.healing),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // OBSERVACIONES
                    // =========================
                    TextFormField(
                      controller: observacionesController,
                      decoration: const InputDecoration(
                        labelText: "Observaciones",
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // BOTONES
                    // =========================
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final nuevo = HistorialModel(
                                  idAnimal: idAnimalSeleccionado!,
                                  fecha: fechaController.text,
                                  diagnostico: diagnosticoController.text,
                                  tratamiento: tratamientoController.text,
                                  observaciones: observacionesController.text,
                                );

                                if (esEditar) {
                                  nuevo.idHistorial = historial!.idHistorial;
                                  await historialRepo.edit(nuevo);
                                } else {
                                  await historialRepo.create(nuevo);
                                }

                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Aceptar"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
