import 'package:flutter/material.dart';

import '../../models/animal_model.dart';
import '../../repositories/animal_repository.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final AnimalRepository repo = AnimalRepository();

  List<AnimalModel> animales = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarAnimales();
  }

  Future<void> cargarAnimales() async {
    setState(() => cargando = true);
    animales = await repo.getAll();
    setState(() => cargando = false);
  }

  // =========================
  // ELIMINAR CON VALIDACIÓN
  // =========================
  void eliminar(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar animal"),
        content: const Text("¿Deseas eliminar este animal?"),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await repo.delete(id);

                Navigator.pop(context);
                cargarAnimales();
              } on Exception catch (e) {
                Navigator.pop(context);

                if (e.toString().contains("ANIMAL_CON_HISTORIAL")) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "No se puede eliminar el animal porque tiene historial médico",
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text("Si"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Animales")),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : animales.isEmpty
          ? const Center(child: Text("No existen animales registrados"))
          : ListView.builder(
              itemCount: animales.length,
              itemBuilder: (_, i) {
                final a = animales[i];

                return Card(
                  child: ListTile(
                    title: Text(a.nombre),
                    subtitle: Text("${a.especieNombre} • ${a.recintoNombre}"),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/animaldetail',
                        arguments: a,
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.orange,
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/animalform',
                              arguments: a,
                            );
                            cargarAnimales();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => eliminar(a.idAnimal!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/animalform');
          cargarAnimales();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
