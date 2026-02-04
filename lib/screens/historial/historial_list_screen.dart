import 'package:flutter/material.dart';

import '../../models/historial_model.dart';
import '../../repositories/historial_repository.dart';

class HistorialListScreen extends StatefulWidget {
  const HistorialListScreen({super.key});

  @override
  State<HistorialListScreen> createState() => _HistorialListScreenState();
}

class _HistorialListScreenState extends State<HistorialListScreen> {
  final HistorialRepository repo = HistorialRepository();

  List<HistorialModel> historial = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarHistorial();
  }

  Future<void> cargarHistorial() async {
    setState(() => cargando = true);
    historial = await repo.getAll();
    setState(() => cargando = false);
  }

  void eliminar(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar historial"),
        content: const Text("¿Estás seguro de eliminar este registro médico?"),
        actions: [
          TextButton(
            onPressed: () async {
              await repo.delete(id);
              Navigator.pop(context);
              cargarHistorial();
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
      appBar: AppBar(title: const Text("Historial Médico")),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : historial.isEmpty
          ? const Center(child: Text("No existen registros"))
          : ListView.builder(
              itemCount: historial.length,
              itemBuilder: (_, i) {
                final h = historial[i];

                return Card(
                  child: ListTile(
                    title: Text(h.diagnostico),
                    subtitle: Text(h.fecha),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.orange,
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/historialform',
                              arguments: h,
                            );
                            cargarHistorial();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => eliminar(h.idHistorial!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/historialform');
          cargarHistorial();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
