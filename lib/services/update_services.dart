
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/data/extensions/database_collections.dart';
import 'package:pokelens/data/extensions/database_pokemon_card.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/services/remote_services.dart';
import 'package:pokelens/widgets/update/snack_bar_widget.dart';
import 'package:pokelens/widgets/update/update_data_widget.dart';
import 'package:sqflite/sqflite.dart';

extension CollectionsExtension on UpdateDataWidgetState{
  
  Future<void> updateCollections(Function() setState) async {
    final List<Collection>? collections = await RemoteService().getCollections();

    if (collections != null) {
      for (Collection collection in collections) {
        try {
          await PokemonDatabaseHelper.instance.insertCollection(collection);
          progress++;
          setState();
        } catch (e) {
          // ignore: avoid_print
          print('Error adding collection: $e');
        }
      }
    }
  }

  Future<void> updatePokemonCards(Function() setState) async {
    List<Map<String, dynamic>> combinedCollectionList = await combineCollectionLists();

    for (Map<String, dynamic> collectionItem in combinedCollectionList) {
      if (mounted) {
        String collectionId = collectionItem['collectionId'];
        int totalCollections = collectionItem['totalCollections'];
        int totalCardsDB = collectionItem['totalCardsDB'];

        //if (collectionId == 'xy11'){
        if (totalCollections > totalCardsDB) {
          List<PokemonCard>? cardsAPI = await RemoteService().getAllCardsByCollection(collectionId);
          //print('Total de cartões na coleção $collectionId: $totalCollections');
          //print('Total de cartões no banco de dados: $totalCardsDB');
          
          for (PokemonCard card in cardsAPI) {
            progress++;
            //print('$progress / $progressGoal  = ${progress/progressGoal}');
            try {
              await PokemonDatabaseHelper.instance.insertPokemonCard(card);
              countPokemonDB++;

              if (mounted) {setState();}

            } catch (e) {
              if (e is DatabaseException && e.isUniqueConstraintError()) {
                // Lidar com a violação da restrição UNIQUE (ID duplicado) aqui
                // ignore: avoid_print
                print('Erro: Já existe uma carta com o ID ${card.id}');
              } else {
                // ignore: avoid_print
                print('Erro ao adicionar cartão: $e');
              }
            }
            showSnackBar('Coleção ${cardsAPI[0].collectionName} atualizada', context);
          }

        } else {
          progress += totalCardsDB;
          print('$progress / $progressGoal  = ${progress/progressGoal}');
          // ignore: avoid_print
          print('Os cartões da coleção $collectionId já estão atualizados');
        }
       // }
      }else{
        break;
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
      // ignore: avoid_print
      print('Erro ao combinar listas de coleções: $e');
      return [];
    }
  }

  Future<void> cauntData() async {
    countPokemonAPI = await RemoteService().getQuantidadeDeCartas();
    countCollectionsAPI = await RemoteService().getQuantidadeDeSets();
    countPokemonDB = await PokemonDatabaseHelper.instance.countPokemon();
    countCollectionsDB = await PokemonDatabaseHelper.instance.countCollections();
    progressGoal = countCollectionsAPI + countPokemonAPI;
  }
}