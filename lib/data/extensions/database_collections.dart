
// Método para obter todas as coleções do banco de dados
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';

extension CollectionsExtension on PokemonDatabaseHelper{

  Future<List<Collection>> getAllCollections() async {
      final db = await database;
      
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT collections.*, 
              SUM(CASE WHEN user_data.tenho = 1 THEN 1 ELSE 0 END) AS totalHave
        FROM collections
        LEFT JOIN pokemon_cards ON collections.id = pokemon_cards.collectionId
        LEFT JOIN user_data ON pokemon_cards.id = user_data.id
        GROUP BY collections.id;
      ''');
      return List.generate(maps.length, (i) {
        return Collection.fromMap(maps[i]);
      });
    }

  Future<Collection?> getCollectionById(String collectionId) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'collections',
      where: 'id = ?',
      whereArgs: [collectionId],
    );

    if (result.isEmpty) {
      // Retorna nulo se a coleção não for encontrada
      return null;
    }

    return Collection.fromMap(result.first);
  }


  Future<List<Map<String, dynamic>>> getAllCollectionTotal() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'collections',
        columns: ['id', 'total'],
        orderBy: 'releaseDate DESC',
      );

      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao obter todas as informações das coleções: $e');
      return [];
    }
  }
}