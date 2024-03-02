// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/services/remote_services.dart';

class UpdateDataWidget extends StatefulWidget {
  const UpdateDataWidget({super.key});

  @override
  UpdateDataWidgetState get createState => UpdateDataWidgetState();
}

class UpdateDataWidgetState extends State<UpdateDataWidget> {
  int countPokemonDB = 0;
  int countPokemonAPI = 0;
  int countCollectionsDB = 0;
  int countCollectionsAPI = 0;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    quantidadeDados();
  }

  Future<void> quantidadeDados() async {
    countPokemonAPI = await RemoteService().getQuantidadeDeCartas();
    countCollectionsAPI = await RemoteService().getQuantidadeDeSets();
    countPokemonDB = await PokemonDatabaseHelper.instance.countPokemon();
    countCollectionsDB = await PokemonDatabaseHelper.instance.countCollections();
    setState(() {});
  }

  Future<void> atualizarDB() async {
    setState(() {
      isUpdating = true;
    });

    final List<Collection>? collections = await RemoteService().getCollections(); //pega da API
    if (collections != null) {
      for (Collection collection in collections) {
        try {
          await PokemonDatabaseHelper.instance.insertCollection(collection);
        } catch (e) {
          print('Error adding collection: $e');
        }
      }
    }

    setState(() {
      isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        Text(
          'Quantidade de Sets baixados: $countCollectionsDB de $countCollectionsAPI',
          style: const TextStyle(fontSize: 18.0),
        ),
        Text(
          'Quantidade de Cartas baixadas: $countPokemonDB de $countPokemonAPI',
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: atualizarDB,
          child: const Text('Atualizar dados'),
        ),
        if (isUpdating) const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text('Carregando dados'),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
           
          ],
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text('Deletar dados'),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text('Exportar dados'),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text('Importar dados'),
        ),
        
      ],
    );
  }
}
