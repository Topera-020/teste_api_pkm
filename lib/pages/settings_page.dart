// ignore_for_file: unnecessary_string_escapes, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

   @override
  SettingsPageState get createState => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  int selectedCardSize = 3; // Valor padrão, pode ser 'Gigante'1 'Grande'2, 'Médio'3, 'Pequeno'4 ou 'Minusculo'5

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tema',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Modo Escuro'),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  // Aqui você pode adicionar lógica para alternar o tema claro/escuro
                  // Por exemplo, pode usar o Theme.of(context).brightness
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tamanho dos Cards',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DropdownButton<int>(
                  value: selectedCardSize,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCardSize = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Gigante'),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text('Grande'),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text('Médio'),
                    ),
                    DropdownMenuItem<int>(
                      value: 4,
                      child: Text('Pequeno'),
                    ),
                    DropdownMenuItem<int>(
                      value: 5,
                      child: Text('Minusculo'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para salvar as configurações
                  // Pode ser feito usando algum gerenciamento de estado (Provider, Bloc, etc.)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configurações Salvas'),
                    ),
                  );
                },
                child: const Text('Salvar Configurações'),
              ),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                'Informações:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Text(
              'Nome do App:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('PokémonCard Scanner'),

            const SizedBox(height: 16),

            const Text(
              'Versão do App:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('1.0.0'),

            const SizedBox(height: 16),

            const Text(
              'Descrição do App:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const Text(
              'Este aplicativo é dedicado à manutenção de cartas Pokémon TCG. '
              'Ele inclui recursos como scanner de cartas usando visão computacional '
              'e armazenamento de dados offline.',
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 32),

            const Text(
              'Atualmente, os dados não estão sendo compartilhados, '
              'pois o aplicativo utiliza armazenamento de dados interno.',
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 32),

            const Text(
              'Este aplicativo foi desenvolvido como parte de um projeto de iniciação científica '
              'por um aluno da Escola de Engenharia de São Carlos - USP, com o apoio da Bolsa PUB. '
              'O aplicativo utiliza apenas ferramentas de código aberto e não tem fins lucrativos. ' 
              'A equipe de desenvolvimento não possui afiliação com a Pokémon Company, Copag ou '
              'qualquer marketplace de cartas colecionáveis.', 
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 32),

            const Text(
              'Desenvolvido por:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Thales Gomes Maurin'),

            const SizedBox(height: 16),

            const Text(
              'Contato:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const Text('Thalesmaurin@gmail.com'),

            const SizedBox(height: 160),
          ],
        ),
      ),
      ),
    );
  }
}
