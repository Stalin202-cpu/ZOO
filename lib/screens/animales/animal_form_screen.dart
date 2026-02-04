import 'package:flutter/material.dart';

import '../../models/animal_model.dart';
import '../../repositories/animal_repository.dart';
import '../../settings/database_connection.dart';

class AnimalFormScreen extends StatefulWidget {
  const AnimalFormScreen({super.key});

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final formAnimal = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final fechaNacimientoController = TextEditingController();

  AnimalModel? animal;

  // Selectores (en lugar de controllers)
  String? sexoSeleccionado;
  String? saludSeleccionada;
  int? idEspecieSeleccionada;
  int? idRecintoSeleccionado;

  // Listas para llenar combos desde tablas relacionadas
  List<Map<String, dynamic>> especies = [];
  List<Map<String, dynamic>> recintos = [];
  bool cargandoCombos = true;
  bool combosCargados = false; // para cargar una sola vez

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 1) Capturo parametros desde la interfaz anterior (editar)
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && animal == null) {
      animal = args as AnimalModel;

      nombreController.text = animal!.nombre;
      fechaNacimientoController.text = animal!.fechaNacimiento;

      sexoSeleccionado = animal!.sexo;
      saludSeleccionada = animal!.estadoSalud;
      idEspecieSeleccionada = animal!.idEspecie;
      idRecintoSeleccionado = animal!.idRecinto;
    }

    // 2) Cargo combos solo una vez (especies y recintos)
    if (!combosCargados) {
      combosCargados = true;
      cargarCombos();
    }
  }

  Future<void> cargarCombos() async {
    setState(() => cargandoCombos = true);

    final db = await DatabaseConnection.instance.db;

    // Traer especies: id y nombre_comun
    especies = await db.query(
      'especies',
      columns: ['id_especie', 'nombre_comun'],
      orderBy: 'nombre_comun ASC',
    );

    // Traer recintos: id y nombre
    recintos = await db.query(
      'recintos',
      columns: ['id_recinto', 'nombre'],
      orderBy: 'nombre ASC',
    );

    setState(() => cargandoCombos = false);
  }

  @override
  void dispose() {
    nombreController.dispose();
    fechaNacimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = animal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar animal" : "Formulario de Animales"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
      ),
      body: cargandoCombos
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formAnimal,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // NOMBRE
                      TextFormField(
                        controller: nombreController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El nombre es requerido";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Nombre",
                          hintText: "Ingrese el nombre del animal",
                          prefixIcon: const Icon(Icons.pets),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // SEXO (SELECTOR)
                      DropdownButtonFormField<String>(
                        value: sexoSeleccionado,
                        items: const [
                          DropdownMenuItem(value: 'Macho', child: Text('Macho')),
                          DropdownMenuItem(value: 'Hembra', child: Text('Hembra')),
                        ],
                        onChanged: (value) {
                          setState(() => sexoSeleccionado = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El sexo es requerido";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Sexo",
                          prefixIcon: const Icon(Icons.wc),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // FECHA NACIMIENTO
                      TextFormField(
                        controller: fechaNacimientoController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "La fecha de nacimiento es requerida";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Fecha nacimiento",
                          hintText: "YYYY-MM-DD",
                          prefixIcon: const Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ESTADO SALUD (SELECTOR)
                      DropdownButtonFormField<String>(
                        value: saludSeleccionada,
                        items: const [
                          DropdownMenuItem(value: 'Bueno', child: Text('Bueno')),
                          DropdownMenuItem(value: 'Regular', child: Text('Regular')),
                          DropdownMenuItem(value: 'Crítico', child: Text('Crítico')),
                        ],
                        onChanged: (value) {
                          setState(() => saludSeleccionada = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "El estado de salud es requerido";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Estado de salud",
                          prefixIcon: const Icon(Icons.health_and_safety),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ESPECIE (TABLA RELACIONADA)
                      DropdownButtonFormField<int>(
                        value: idEspecieSeleccionada,
                        items: especies.map((e) {
                          return DropdownMenuItem<int>(
                            value: e['id_especie'] as int,
                            child: Text(e['nombre_comun'].toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => idEspecieSeleccionada = value);
                        },
                        validator: (value) {
                          if (value == null) return "La especie es requerida";
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Especie",
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // RECINTO (TABLA RELACIONADA)
                      DropdownButtonFormField<int>(
                        value: idRecintoSeleccionado,
                        items: recintos.map((r) {
                          return DropdownMenuItem<int>(
                            value: r['id_recinto'] as int,
                            child: Text(r['nombre'].toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => idRecintoSeleccionado = value);
                        },
                        validator: (value) {
                          if (value == null) return "El recinto es requerido";
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Recinto",
                          prefixIcon: const Icon(Icons.home_work),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // BOTONES (MISMA ESTRUCTURA)
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                if (formAnimal.currentState!.validate()) {
                                  final repo = AnimalRepository();

                                  final nuevo = AnimalModel(
                                    nombre: nombreController.text,
                                    sexo: sexoSeleccionado!,
                                    fechaNacimiento: fechaNacimientoController.text,
                                    estadoSalud: saludSeleccionada!,
                                    idEspecie: idEspecieSeleccionada!,
                                    idRecinto: idRecintoSeleccionado!,
                                  );

                                  if (esEditar) {
                                    nuevo.id = animal!.id;
                                    await repo.edit(nuevo);
                                  } else {
                                    await repo.create(nuevo);
                                  }

                                  Navigator.pop(context);
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Aceptar"),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Cancelar"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
