import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[700],
              
      
            ),
            child: const Text('Menu', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
          ),
          ListTile(
            title: const Text('Opção 1'),
            onTap: () {
              // Lógica quando a Opção 1 é selecionada
            },
          ),
          ListTile(
            title: const Text('Opção 2'),
            onTap: () {
              // Lógica quando a Opção 2 é selecionada
            },
          ),
        ],
      ),
    );
  }
}
