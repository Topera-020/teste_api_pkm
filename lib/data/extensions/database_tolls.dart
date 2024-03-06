// Método para exportar dados do banco de dados para arquivos CSV
import 'dart:io';
import 'package:pokelens/data/database_helper.dart';

extension ToolsExtension on PokemonDatabaseHelper{
  Future<void> exportToCSV() async {
    final db = await database;

    // Exporta dados da tabela 'pokemon_cards'
    final List<Map<String, dynamic>> pokemonCards = await db.query('pokemon_cards');
    final csvPokemonCards = List<List<dynamic>>.from(pokemonCards.map((card) => card.values.toList()));
    csvPokemonCards.insert(0, pokemonCards[0].keys.toList());

    final pokemonCardsFile = File('pokemon_cards.csv');
    await pokemonCardsFile.writeAsString(csvPokemonCards.map((row) => row.join(',')).join('\n'));

    // Exporta dados da tabela 'collections'
    final List<Map<String, dynamic>> collections = await db.query('collections');
    final csvCollections = List<List<dynamic>>.from(collections.map((collection) => collection.values.toList()));
    csvCollections.insert(0, collections[0].keys.toList());

    final collectionsFile = File('collections.csv');
    await collectionsFile.writeAsString(csvCollections.map((row) => row.join(',')).join('\n'));

    // ignore: avoid_print
    print('Exportação para CSV concluída.');
  }
}