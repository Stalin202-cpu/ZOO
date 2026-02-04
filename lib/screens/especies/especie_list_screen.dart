import 'package:flutter/material.dart';

import '../../models/especie_model.dart';
import '../../repositories/especie_repository.dart';

class EspecieScreen extends StatefulWidget {
  const EspecieScreen({super.key});

  @override
  State<EspecieScreen> createState() => _EspecieScreenState();
}

class _EspecieScreenState extends State<EspecieScreen> {
  final EspecieRepository repo = EspecieRepository();

  List<EspecieModel> especies = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarEspecies();
  }

  Future<void> cargarEspecies() async {
    setState(() => cargando = true);
    especies = await repo.getAll();
    setState(() => cargando = false);
  }

 void eliminarEspecie(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar especie"),
        content: const Text("¿Estás seguro que deseas eliminar esta especie?"),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                // intento eliminar
                await repo.delete(id);

                Navigator.pop(context);
                cargarEspecies();
              } catch (e) {
                // si falla (tiene animales)
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No se puede eliminar la especie porque tiene animales asociados",
                    ),
                  ),
                );
              }
            },
            child: const Text("Si"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listado de Especies")),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : especies.isEmpty
          ? const Center(child: Text("No existen datos"))
          : ListView.builder(
              itemCount: especies.length,
              itemBuilder: (context, i) {
                final esp = especies[i];

                return Card(
                  child: ListTile(
                    title: Text(esp.nombreComun),
                    subtitle: Text("${esp.nombreCientifico} • ${esp.habitat}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/especieform',
                              arguments: esp,
                            );
                            cargarEspecies();
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.orange,
                        ),
                        IconButton(
                          onPressed: () => eliminarEspecie(esp.idEspecie!),
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/especieform');
          cargarEspecies();
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
    );
  }
}
