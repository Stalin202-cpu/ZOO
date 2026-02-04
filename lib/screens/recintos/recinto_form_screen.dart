import 'package:flutter/material.dart';
import '../../models/recinto_model.dart';
import '../../repositories/recinto_repository.dart';

class RecintoForm extends StatefulWidget {
  const RecintoForm({super.key});

  @override
  State<RecintoForm> createState() => _RecintoFormState();
}

class _RecintoFormState extends State<RecintoForm> {
  final formRecinto = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final tipoController = TextEditingController();
  final capacidadController = TextEditingController();
  final ubicacionController = TextEditingController();

  RecintoModel? recinto;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      recinto = args as RecintoModel;

      nombreController.text = recinto!.nombre;
      tipoController.text = recinto!.tipo;
      capacidadController.text = recinto!.capacidad.toString();
      ubicacionController.text = recinto!.ubicacion;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    tipoController.dispose();
    capacidadController.dispose();
    ubicacionController.dispose();
    super.dispose();
  }

  bool _esEntero(String value) => int.tryParse(value) != null;

  @override
  Widget build(BuildContext context) {
    final esEditar = recinto != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? "Editar recinto" : "Insertar recinto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formRecinto,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                TextFormField(
                  controller: nombreController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "El nombre es requerido";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    hintText: "Ingrese el nombre del recinto",
                    prefixIcon: const Icon(Icons.home_work),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: tipoController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "El tipo es requerido";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Tipo",
                    hintText: "Ej: Acuático, Terrestre, Aves...",
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: capacidadController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "La capacidad es requerida";
                    }
                    if (!_esEntero(value.trim())) {
                      return "La capacidad debe ser un número entero";
                    }
                    final cap = int.parse(value.trim());
                    if (cap <= 0) {
                      return "La capacidad debe ser mayor a 0";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Capacidad",
                    hintText: "Ingrese la capacidad del recinto",
                    prefixIcon: const Icon(Icons.groups),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: ubicacionController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "La ubicación es requerida";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Ubicación",
                    hintText: "Ej: Zona norte, Bloque B...",
                    prefixIcon: const Icon(Icons.place),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            if (!formRecinto.currentState!.validate()) return;

                            final repo = RecintoRepository();

                            final nuevoRecinto = RecintoModel(
                              nombre: nombreController.text.trim(),
                              tipo: tipoController.text.trim(),
                              capacidad: int.parse(
                                capacidadController.text.trim(),
                              ),
                              ubicacion: ubicacionController.text.trim(),
                            );

                            if (esEditar) {
                              nuevoRecinto.idRecinto = recinto!.idRecinto;
                              await repo.edit(nuevoRecinto);
                            } else {
                              await repo.create(nuevoRecinto);
                            }

                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Text(
                              "Aceptar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Center(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
