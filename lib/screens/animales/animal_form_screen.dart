import 'package:flutter/material.dart';

import '../../models/animal_model.dart';
import '../../models/especie_model.dart';
import '../../models/recinto_model.dart';

import '../../repositories/animal_repository.dart';
import '../../repositories/especie_repository.dart';
import '../../repositories/recinto_repository.dart';

class AnimalFormScreen extends StatefulWidget {
  const AnimalFormScreen({super.key});

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final fechaController = TextEditingController();
  final estadoSaludController = TextEditingController();

  String? sexoSeleccionado;
  int? idEspecieSeleccionada;
  int? idRecintoSeleccionado;

  List<EspecieModel> especies = [];
  List<RecintoModel> recintos = [];

  AnimalModel? animal;

  final animalRepo = AnimalRepository();
  final especieRepo = EspecieRepository();
  final recintoRepo = RecintoRepository();

  bool cargando = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is AnimalModel) {
      animal = args;

      nombreController.text = animal!.nombre;
      fechaController.text = animal!.fechaNacimiento;
      estadoSaludController.text = animal!.estadoSalud;

      sexoSeleccionado = animal!.sexo;
      idEspecieSeleccionada = animal!.idEspecie;
      idRecintoSeleccionado = animal!.idRecinto;
    }

    cargarDatos();
  }

  Future<void> cargarDatos() async {
    especies = await especieRepo.getAll();
    recintos = await recintoRepo.getAll();

    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = animal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar animal" : "Registrar animal"),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    // =========================
                    // NOMBRE
                    // =========================
                    TextFormField(
                      controller: nombreController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Nombre requerido" : null,
                      decoration: const InputDecoration(
                        labelText: "Nombre",
                        prefixIcon: Icon(Icons.pets),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // SEXO
                    // =========================
                    DropdownButtonFormField<String>(
                      value: sexoSeleccionado,
                      items: const [
                        DropdownMenuItem(value: "Macho", child: Text("Macho")),
                        DropdownMenuItem(
                          value: "Hembra",
                          child: Text("Hembra"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => sexoSeleccionado = value);
                      },
                      validator: (v) => v == null ? "Seleccione el sexo" : null,
                      decoration: const InputDecoration(
                        labelText: "Sexo",
                        prefixIcon: Icon(Icons.wc),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // FECHA NACIMIENTO
                    // =========================
                    TextFormField(
                      controller: fechaController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Fecha requerida" : null,
                      decoration: const InputDecoration(
                        labelText: "Fecha nacimiento",
                        prefixIcon: Icon(Icons.date_range),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // ESTADO SALUD
                    // =========================
                    DropdownButtonFormField<String>(
                      value: estadoSaludController.text.isEmpty
                          ? null
                          : estadoSaludController.text,
                      validator: (v) => v == null || v.isEmpty
                          ? "Estado de salud requerido"
                          : null,
                      items: const [
                        DropdownMenuItem(value: "Bajo", child: Text("Bajo")),
                        DropdownMenuItem(value: "Medio", child: Text("Medio")),
                        DropdownMenuItem(value: "Alto", child: Text("Alto")),
                      ],
                      onChanged: (value) {
                        estadoSaludController.text = value!;
                      },
                      decoration: const InputDecoration(
                        labelText: "Estado de salud",
                        prefixIcon: Icon(Icons.health_and_safety),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // ESPECIE
                    // =========================
                    DropdownButtonFormField<int>(
                      value: idEspecieSeleccionada,
                      items: especies
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.idEspecie,
                              child: Text(e.nombreComun),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => idEspecieSeleccionada = v),
                      validator: (v) =>
                          v == null ? "Seleccione una especie" : null,
                      decoration: const InputDecoration(
                        labelText: "Especie",
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // RECINTO
                    // =========================
                    DropdownButtonFormField<int>(
                      value: idRecintoSeleccionado,
                      items: recintos
                          .map(
                            (r) => DropdownMenuItem(
                              value: r.idRecinto,
                              child: Text(r.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => idRecintoSeleccionado = v),
                      validator: (v) =>
                          v == null ? "Seleccione un recinto" : null,
                      decoration: const InputDecoration(
                        labelText: "Recinto",
                        prefixIcon: Icon(Icons.home),
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
                                final nuevo = AnimalModel(
                                  nombre: nombreController.text,
                                  sexo: sexoSeleccionado!,
                                  fechaNacimiento: fechaController.text,
                                  estadoSalud: estadoSaludController.text,
                                  idEspecie: idEspecieSeleccionada!,
                                  idRecinto: idRecintoSeleccionado!,
                                );

                                if (esEditar) {
                                  nuevo.idAnimal = animal!.idAnimal;
                                  await animalRepo.edit(nuevo);
                                } else {
                                  await animalRepo.create(nuevo);
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
