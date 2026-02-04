import 'package:flutter/material.dart';
import '../../models/especie_model.dart';
import '../../repositories/especie_repository.dart';

class EspecieForm extends StatefulWidget {
  const EspecieForm({super.key});

  @override
  State<EspecieForm> createState() => _EspecieFormState();
}

class _EspecieFormState extends State<EspecieForm> {
  final formEspecie = GlobalKey<FormState>();

  final nombreComunController = TextEditingController();
  final nombreCientificoController = TextEditingController();
  final alimentacionController = TextEditingController();
  final habitatController = TextEditingController();
  final nivelPeligroController = TextEditingController();

  EspecieModel? especie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // capturo parametros desde la interfaz
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null) {
      especie = args as EspecieModel;

      nombreComunController.text = especie!.nombreComun;
      nombreCientificoController.text = especie!.nombreCientifico;
      alimentacionController.text = especie!.alimentacion;
      habitatController.text = especie!.habitat;
      nivelPeligroController.text = especie!.nivelPeligro;
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = especie != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar especie" : "Insertar especie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formEspecie,
          child: Column(
            children: [
              SizedBox(height: 20),

              // =========================
              // NOMBRE COMUN
              // =========================
              TextFormField(
                controller: nombreComunController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre común es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nombre común",
                  hintText: "Ingrese el nombre común",
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // =========================
              // NOMBRE CIENTIFICO
              // =========================
              TextFormField(
                controller: nombreCientificoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nombre científico es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nombre científico",
                  hintText: "Ingrese el nombre científico",
                  prefixIcon: Icon(Icons.science),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // =========================
              // ALIMENTACION
              // =========================
              TextFormField(
                controller: alimentacionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La alimentación es requerida";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Alimentación",
                  hintText: "Ingrese la alimentación",
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // =========================
              // HABITAT
              // =========================
              TextFormField(
                controller: habitatController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El hábitat es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Hábitat",
                  hintText: "Ingrese el hábitat",
                  prefixIcon: Icon(Icons.landscape),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // =========================
              // NIVEL PELIGRO
              // =========================
              TextFormField(
                controller: nivelPeligroController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El nivel de peligro es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Nivel de peligro",
                  hintText: "Ingrese el nivel de peligro",
                  prefixIcon: Icon(Icons.warning),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // =========================
              // BOTONES
              // =========================
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (formEspecie.currentState!.validate()) {
                                  final repo = EspecieRepository();

                                  final nuevaEspecie = EspecieModel(
                                    nombreComun: nombreComunController.text,
                                    nombreCientifico:
                                        nombreCientificoController.text,
                                    alimentacion: alimentacionController.text,
                                    habitat: habitatController.text,
                                    nivelPeligro: nivelPeligroController.text,
                                  );

                                  if (esEditar) {
                                    nuevaEspecie.idEspecie = especie!.idEspecie;
                                    await repo.edit(nuevaEspecie);
                                  } else {
                                    await repo.create(nuevaEspecie);
                                  }

                                  Navigator.pop(context);
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
