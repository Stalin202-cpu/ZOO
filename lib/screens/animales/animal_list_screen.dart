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

  void eliminarAnimal(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar animal"),
        content: const Text("¿Estás seguro de eliminar este registro?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarAnimales();
            },
            child: const Text("Sí"),
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
      appBar: AppBar(
        title: const Text("Listado de Animales"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : animales.isEmpty
              ? const Center(child: Text("No existen datos"))
              : ListView.builder(
                  itemCount: animales.length,
                  itemBuilder: (context, i) {
                    final a = animales[i];
                    return Card(
                      child: ListTile(
                        title: Text(a.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sexo: ${a.sexo}"),
                            Text("Salud: ${a.estadoSalud}"),
                            Text("Nacimiento: ${a.fechaNacimiento}"),
                          ],
                        ),
                        onTap: () async {
                          // Ir al detalle (pasando el animal)
                          await Navigator.pushNamed(
                            context,
                            '/animal/detail',
                            arguments: a,
                          );
                          cargarAnimales();
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  '/animal/form',
                                  arguments: a, // editar
                                );
                                cargarAnimales();
                              },
                              icon: const Icon(Icons.edit, color: Colors.amber),
                            ),
                            IconButton(
                              onPressed: () => eliminarAnimal(a.id!),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/animal/form'); // crear
          cargarAnimales();
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
