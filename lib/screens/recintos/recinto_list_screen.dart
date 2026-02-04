import 'package:flutter/material.dart';
import '../../models/recinto_model.dart';
import '../../repositories/recinto_repository.dart';

class RecintoScreen extends StatefulWidget {
  const RecintoScreen({super.key});

  @override
  State<RecintoScreen> createState() => _RecintoScreenState();
}

class _RecintoScreenState extends State<RecintoScreen> {
  final RecintoRepository repo = RecintoRepository();

  List<RecintoModel> recintos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarRecintos();
  }

  Future<void> cargarRecintos() async {
    setState(() => cargando = true);
    recintos = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminarRecinto(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar recinto"),
        content: const Text("¿Estás seguro que deseas eliminar este recinto?"),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await repo.delete(id);
                if (!mounted) return;
                Navigator.pop(context);
                cargarRecintos();
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No se puede eliminar el recinto porque tiene animales asignados",
                    ),
                  ),
                );
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
      appBar: AppBar(title: const Text("Listado de Recintos")),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : recintos.isEmpty
          ? const Center(child: Text("No existen datos"))
          : ListView.builder(
              itemCount: recintos.length,
              itemBuilder: (context, i) {
                final r = recintos[i];

                return Card(
                  child: ListTile(
                    title: Text(r.nombre),
                    subtitle: Text(
                      "${r.tipo} • Cap: ${r.capacidad} • ${r.ubicacion}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/recintoform',
                              arguments: r,
                            );
                            cargarRecintos();
                          },
                          icon: const Icon(Icons.edit),
                          color: Colors.orange,
                        ),
                        IconButton(
                          onPressed: () => eliminarRecinto(r.idRecinto!),
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
          await Navigator.pushNamed(context, '/recintoform');
          cargarRecintos();
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
    );
  }
}
