import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu de opciones")),
      body: Column(
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/especies');
              },
              child: Text("Ir a especies"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
