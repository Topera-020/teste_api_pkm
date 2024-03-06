
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
  int progress = 0;
  bool isUpdating = false;
  int progressGoal = 1;  

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
    progressGoal = countCollectionsAPI + countPokemonAPI;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateCollections() async {
    final List<Collection>? collections = await RemoteService().getCollections();
    if (collections != null) {
      for (Collection collection in collections) {
        try {
          await PokemonDatabaseHelper.instance.insertCollection(collection);
          progress++;
        } catch (e) {
          print('Error adding collection: $e');
        }
      }
    }
    if (mounted) {
      setState(() {});
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
      if (mounted) {
        String collectionId = collectionItem['collectionId'];
        int totalCollections = collectionItem['totalCollections'];
        int totalCardsDB = collectionItem['totalCardsDB'];

        //if (collectionId == 'xy11'){
          if (totalCollections > totalCardsDB) {
            List<PokemonCard>? cardsAPI = await RemoteService().getAllCardsByCollection(collectionId);
            print('Total de cartões na coleção $collectionId: $totalCollections');
            print('Total de cartões no banco de dados: $totalCardsDB');
            
            for (PokemonCard card in cardsAPI) {
              progress++;
              //print('$progress / $progressGoal  = ${progress/progressGoal}');
              try {
                await PokemonDatabaseHelper.instance.insertPokemonCard(card);
                await PokemonDatabaseHelper.instance.insertUserData(card.id);
                countPokemonDB++;
                if (mounted) {
                  setState(() {});
                }
              } catch (e) {
                print('Erro ao adicionar cartão: $e');
              }
            }
            showSnackBar('Coleção ${cardsAPI[0].collectionName} atualizada', context);
          } else {
            progress += totalCardsDB;
            //print('$progress / $progressGoal  = ${progress/progressGoal}');
            print('Os cartões da coleção $collectionId já estão atualizados');
          }
       // }
      }else{
        break;
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Tem certeza que deseja excluir os dados?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar exclusão
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar exclusão
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateDB() async {
    progress = 0;
    if (mounted) {
      setState(() {
        isUpdating = true;
      });
    }
    await updateCollections();
    await updatePokemonCards();

    await cauntData();
    if (mounted) {
      setState(() {
        isUpdating = false;
      });
    }
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Center(child: Text(message)));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        IgnorePointer(
          ignoring: isUpdating,
          child: ElevatedButton(
            onPressed: isUpdating ? null : updateDB,
            child: const Text('Atualizar dados'),
          ),
        ),
        if (isUpdating)
          Column(
            children: [
              LinearProgressIndicator(
                value: (progress /progressGoal),
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Progresso: ${(progress / progressGoal * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
        ElevatedButton(
          onPressed: (countPokemonDB == 0 && countCollectionsDB == 0 || isUpdating)
              ? null // Botão desativado se countPokemonDB ou countCollectionsDB for 0
              : () async {
                  bool? confirmDelete = await _showDeleteConfirmationDialog(context);

                  if (confirmDelete!) {
                    // Executar exclusão
                    await PokemonDatabaseHelper.instance.removeAllCollections();
                    await PokemonDatabaseHelper.instance.removeAllPokemonCards();
                    //await PokemonDatabaseHelper.instance.removeAllUserData();
                    await cauntData();

                    if (mounted) {
                      setState(() {});
                    }

                    showSnackBar('Dados excluídos com sucesso!', context);
                  }
                },
          child: Text('Excluir dados gerais'),
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