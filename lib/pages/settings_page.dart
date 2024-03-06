import 'package:flutter/material.dart';
import 'package:pokelens/widgets/global/drawer_widget.dart';
import 'package:pokelens/widgets/update/update_data_widget.dart';

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
              const SizedBox(height: 16),
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
