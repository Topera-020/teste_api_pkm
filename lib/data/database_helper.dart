

import 'package:pokelens/data/extensions/database_init.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:sqflite/sqflite.dart';


class PokemonDatabaseHelper {
  // Instância única da classe para garantir uma única conexão ao banco de dados
  static Database? _database;  // Alterado para Database? para permitir nulos
  static final PokemonDatabaseHelper instance = PokemonDatabaseHelper._();

  // Construtor privado para garantir que a classe seja utilizada como singleton
  PokemonDatabaseHelper._();

  // Método getter assíncrono para obter a instância do banco de dados
  Future<Database> get database async {
    // Retorna a instância existente se já estiver inicializada
    if (_database != null) return _database!;

    // Caso contrário, inicializa o banco de dados e retorna a instância
    _database = await initDatabase();
    return _database!;
  }
  
  Future<List<Map<String, dynamic>>> listByCollectionId(String collectionId) async {
  try {
    final Database db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT collectionId, COUNT(*) as total FROM pokemon_cards WHERE collectionId = ? GROUP BY collectionId',
      [collectionId],
    );

    return result;
  } catch (e) {
    // ignore: avoid_print
    print('Erro ao contar cartões por collectionId: $e');
    return [];
  }
}

  // Método para inserir uma coleção no banco de dados
  Future<int> insertCollection(Collection collection) async {
    final db = await database;
    
    // Verifica se o ID da coleção já existe
    final existingCollection = await db.query(
      'collections',
      where: 'id = ?',
      whereArgs: [collection.id],
    );

    if (existingCollection.isNotEmpty) {
      // O ID já existe; você pode lidar com isso conforme necessário
      // ignore: avoid_print
      print('Collection with ID ${collection.id} already exists.');
      return -1; // Ou algum outro valor para indicar falha
    }

    try {
      // O ID não existe, prossegue com a inserção
      return await db.insert('collections', {
        'id': collection.id,
        'name': collection.name,
        'series': collection.series,
        'printedTotal': collection.printedTotal,
        'total': collection.total,
        'ptcgoCode': collection.ptcgoCode,
        'releaseDate': collection.releaseDate,
        'symbolImg': collection.symbolImg,
        'logoImg': collection.logoImg
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error inserting Collection: $e');
      return -1; // Retorna um valor que indica falha na inserção
    }
  }

  

  Future<List<Map<String, dynamic>>> countAllPokemonCardsByCollectionId() async {
    try {
      final Database db = await instance.database;

      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT collectionId, COUNT(*) as total FROM pokemon_cards GROUP BY collectionId',
      );

      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao contar cartões por collectionId: $e');
      return [];
    }
  }

  Future<void> removeAllPokemonCards() async {
    final db = await instance.database;
    await db.delete('pokemon_cards');
  }

  Future<void> removeAllCollections() async {
    final db = await instance.database;
    await db.delete('collections');
  }
  Future<void> removeAllUserData() async {
    final db = await instance.database;
    await db.delete('user_data');
  }

  // Método para contar o número de cartas de Pokémon no banco de dados
  Future<int> countPokemon() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM pokemon_cards');
    return Sqflite.firstIntValue(result) ?? 0;  // Retorna o número de registros na tabela
  }

  // Método para contar o número de coleções no banco de dados
  Future<int> countCollections() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM collections');
    return Sqflite.firstIntValue(result) ?? 0;  // Retorna o número de registros na tabela
  }

  


}
