import 'package:flutter/material.dart';
import 'package:pokelens/widgets/drawer_widget.dart';
import 'package:pokelens/widgets/update_data_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(height: 32),
              Text(
                      'Dados dos cards',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
              const Center(
                child: UpdateDataWidget(), // Adicionando o UpdateDataWidget
              ),
            ],
          ),
        ),
      ),
    );
  }
}
