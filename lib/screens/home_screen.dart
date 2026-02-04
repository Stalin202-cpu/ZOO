import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu de opciones")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/especies');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Ir a especies"),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recintos');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Ir a recintos"),
            ),
          ),
        ],
      ),
    );
  }
}
