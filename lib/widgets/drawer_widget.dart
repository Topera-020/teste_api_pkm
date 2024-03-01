import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 4, 60, 60),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ),
            
            ListTile(
              leading: const Icon(Icons.camera_alt), // Ícone de câmera para representar o Scanner de cartas
              title: const Text('Scanner de Cartas'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicione a lógica ou navegação necessária para o Scanner de Cartas aqui
              },
            ),

            ListTile(
              leading: const Icon(Icons.apps_rounded),
              title: const Text('Todas as Cartas'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicione aqui a lógica para navegar para a página de todas as cartas
              },
            ),

            ListTile(
              leading: const Icon(Icons.pets), // Ícone de mascote para representar a Pokedex
              title: const Text('Pokedex'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicione a lógica ou navegação necessária para a Pokedex aqui
              },
            ),

            ListTile(
              leading: const Icon(Icons.collections_bookmark), // Ícone de livro para representar Sets Oficiais
              title: const Text('Sets Oficiais'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicione a lógica ou navegação necessária para Sets Oficiais aqui
              },
            ),

            ListTile(
              leading: const Icon(Icons.list), // Ícone de lista para representar Listas pessoais
              title: const Text('Listas Pessoais'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                Navigator.pushNamed(context, '/loading'); 
              },
            ),

            ListTile(
              leading: const Icon(Icons.bar_chart), // Ícone de gráfico de barras para representar Estatísticas
              title: const Text('Estatísticas'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, '/test'); 
              },
            ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, '/settings'); 
            },
          ),
        ],
      ),
    );
  }
}
