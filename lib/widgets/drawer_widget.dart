import 'package:flutter/material.dart';
import 'package:teste_api/pages/settings_page.dart';


class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

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
            child: const Text(
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
                // Adicione a lógica ou navegação necessária para Listas Pessoais aqui
              },
            ),

            ListTile(
              leading: const Icon(Icons.bar_chart), // Ícone de gráfico de barras para representar Estatísticas
              title: const Text('Estatísticas'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicione a lógica ou navegação necessária para Estatísticas aqui
              },
            ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()), // Substituído InfoPage por SettingsPage
              );
            },
          ),
        ],
      ),
    );
  }
}
