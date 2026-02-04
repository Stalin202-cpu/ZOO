import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menú del Zoológico"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // =========================
            // IMAGEN ZOOLÓGICO
            // =========================
            Center(
              child: Image.asset(
                'assets/images/image1.jpg',
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // FILA 1: ESPECIES - RECINTOS
            // =========================
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/especies');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Especies"),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/recintos');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Recintos"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // =========================
            // FILA 2: ANIMALES - HISTORIAL
            // =========================
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/animales');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Animales"),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/historial');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Historial Médico"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
