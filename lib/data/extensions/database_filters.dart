

import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/pokemon_card_model.dart';

extension CollectionsExtension on PokemonDatabaseHelper{
  Future<List<PokemonCard>?> getFilteredAndSortedPokemonCards({
    String? collectionId,
    String? searchTerm,
    String? filterColumn,
    bool? isAscending,
  }) async {
    final db = await database;

    // Monta a cláusula WHERE baseada no searchTerm e filterColumn
    String whereClause = '';
    List<dynamic> whereArgs = [];
    if (searchTerm != null && filterColumn != null) {
      whereClause = 'LOWER($filterColumn) LIKE ?';
      whereArgs = ['%${searchTerm.toLowerCase()}%'];
    }

    // Monta a cláusula ORDER BY baseada na ordenação e na direção
    String orderByClause = 'pc.numberINT';
    if (isAscending != null) {
      orderByClause += isAscending ? ' ASC' : ' DESC';
    }

    // Monta a consulta SQL final
    String query = '''
      SELECT pc.*, c.releaseDate, c.name AS collectionName, c.series, GROUP_CONCAT(t.name) AS tags
      FROM pokemon_cards pc
      JOIN collections c ON pc.collectionId = c.id
      LEFT JOIN card_tag_association cta ON pc.id = cta.card_id
      LEFT JOIN tags t ON cta.tag_id = t.id
      ${whereClause.isNotEmpty ? 'WHERE $whereClause' : ''}
      ${collectionId != null ? 'AND pc.collectionId = ?' : ''}
      GROUP BY pc.id
      ORDER BY $orderByClause
    ''';

    // Adiciona collectionId aos argumentos se fornecido
    if (collectionId != null) {
      whereArgs.add(collectionId);
    }

    // Executa a consulta
    List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);

    // Mapeia os resultados para objetos PokemonCard
    return List.generate(maps.length, (i) {
      PokemonCard card = PokemonCard.fromMap(maps[i]);
      return card;
    });
  }
}