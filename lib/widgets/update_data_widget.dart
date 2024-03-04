// ignore_for_file: avoid_print, prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
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

  double get progress {
    if (countPokemonAPI + countCollectionsAPI == 0) {
      return 0.0; // Para evitar divisão por zero
    }
    return ((countPokemonDB + countCollectionsDB) / (countPokemonAPI + countCollectionsAPI)) * 100;
  }

  @override
  void initState() {
    super.initState();
    cauntData();
  }

  Future<void> cauntData() async {
    countPokemonAPI = await RemoteService().getQuantidadeDeCartas();
    countCollectionsAPI = await RemoteService().getQuantidadeDeSets();
    countPokemonDB = await PokemonDatabaseHelper.instance.countPokemon();
    countCollectionsDB = await PokemonDatabaseHelper.instance.countCollections();
    setState(() {});
  }

  Future<void> updateCollections() async {
    final List<Collection>? collections = await RemoteService().getCollections();
    if (collections != null) {
      for (Collection collection in collections) {
        try {
          await PokemonDatabaseHelper.instance.insertCollection(collection);
        } catch (e) {
          print('Error adding collection: $e');
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> combineCollectionLists() async {
    try {
      final List<Map<String, dynamic>> collectionInfoList =
          await PokemonDatabaseHelper.instance.getAllCollectionTotal();

      final List<Map<String, dynamic>> countCardsInCollectionDB =
          await PokemonDatabaseHelper.instance.countAllPokemonCardsByCollectionId();

      // Unindo as listas
      List<Map<String, dynamic>> combinedList = collectionInfoList.map((collectionInfo) {
        // Encontrar a contagem correspondente usando o collectionId
        Map<String, dynamic>? countInfo = countCardsInCollectionDB.firstWhere(
          (count) => count['collectionId'] == collectionInfo['id'],
          orElse: () => {'total': 0},
        );

        // Unir os resultados em um novo mapa
        return {
          'collectionId': collectionInfo['id'],
          'totalCollections': collectionInfo['total'],
          'totalCardsDB': countInfo['total'],
        };
      }).toList();

      return combinedList;
    } catch (e) {
      print('Erro ao combinar listas de coleções: $e');
      return [];
    }
  }

  Future<void> updatePokemonCards() async {
    List<Map<String, dynamic>> combinedCollectionList = await combineCollectionLists();

    for (Map<String, dynamic> collectionItem in combinedCollectionList) {
      String collectionId = collectionItem['collectionId'];
      int totalCollections = collectionItem['totalCollections'];
      int totalCardsDB = collectionItem['totalCardsDB'];

      if (totalCollections > totalCardsDB) {
        List<PokemonCard>? cardsAPI = await RemoteService().getAllCardsByCollection(collectionId);
        print('Total de cartões na coleção $collectionId: $totalCollections');
        print('Total de cartões no banco de dados: $totalCardsDB');
        for (PokemonCard card in cardsAPI) {
          try {
            await PokemonDatabaseHelper.instance.insertPokemonCard(card);
          } catch (e) {
            print('Erro ao adicionar cartão: $e');
          }
        }
      } else {
        print('Os cartões da coleção $collectionId já estão atualizados');
      }

      countPokemonDB = await PokemonDatabaseHelper.instance.countPokemon();
      countCollectionsDB = await PokemonDatabaseHelper.instance.countCollections();
      setState(() {});
    }
  }



  Future<void> updateDB() async {
    setState(() {
      isUpdating = true;
    });
    await updateCollections();
    await updatePokemonCards();

    await cauntData();

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
          onPressed: updateDB,
          child: const Text('Atualizar dados'),
        ),
        if (isUpdating)
          Column(
            children: [
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Progresso: ${progress.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
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
