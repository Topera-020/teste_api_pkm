// Método para obter todas as coleções do banco de dados
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';

extension CollectionsExtension on PokemonDatabaseHelper {
  String mapOrderBy(String original) {
    switch (original) {
      case 'Data':
        return 'releaseDate';
      case 'Nome':
        return 'name';
      case 'Série':
        return 'series';
      case '# Cartas':
        return 'total';
      default:
        return original;
    }
  }

  Future<List<Collection>> getCollections({
    List<String>? collectionId,

    String? nameSearch,
    String? seriesSearch,
    int? printedTotalSearch,
    int? totalSearch,
    String? ptcgoCodeSearch,
    String? releaseDateSearch,

    String? searchTerm,

    bool? isAscending1,
    bool? isAscending2,
    
    String primaryOrderByClause = 'releaseDate',
    String secondaryOrderByClause = 'releaseDate',
  }) async {
    final db = await database;

    primaryOrderByClause = mapOrderBy(primaryOrderByClause);
    secondaryOrderByClause = mapOrderBy(secondaryOrderByClause);

    // Monta a cláusula WHERE baseada no searchTerm e filterColumn
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null) {
      whereClause = '''
        LOWER(name) LIKE ? OR 
        LOWER(series) LIKE ? OR 
        printedTotal = ? OR 
        total = ? OR 
        LOWER(ptcgoCode) LIKE ? OR 
        LOWER(releaseDate) LIKE ?
      ''';

      whereArgs = List.filled(6, '%$searchTerm%');
    } else {
      if (nameSearch != null) {
        whereClause += 'LOWER(name) LIKE ? ';
        whereArgs.add('%$nameSearch%');
      }

      if (seriesSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(series) LIKE ? ';
        whereArgs.add('%$seriesSearch%');
      }

      if (printedTotalSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'printedTotal = ? ';
        whereArgs.add(printedTotalSearch);
      }

      if (totalSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'total = ? ';
        whereArgs.add(totalSearch);
      }

      if (ptcgoCodeSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(ptcgoCode) LIKE ? ';
        whereArgs.add('%$ptcgoCodeSearch%');
      }

      if (releaseDateSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$releaseDateSearch%');
      }
    }

    // Monta a cláusula ORDER BY baseada na ordenação e na direção
    String orderClause = '$primaryOrderByClause ${isAscending1 != null ? (isAscending1 ? 'ASC' : 'DESC') : 'DESC'}, '
        '$secondaryOrderByClause ${isAscending2 != null ? (isAscending2 ? 'ASC' : 'DESC') : 'DESC'}';

    String query = '''
      SELECT *
      FROM collections
      ${whereClause.isNotEmpty ? 'WHERE $whereClause' : ''}
      ORDER BY $orderClause;
    ''';

    // Executa a consulta e mapeia diretamente para objetos Collection
    List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);
    return maps.map((map) => Collection.fromMap(map)).toList();
  }

  // Usa no update
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

  Future<Collection?> getCollectionById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'collections',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      //print('result $result');
      return Collection.fromMap(result.first);
    } else {
      // Retorna um mapa vazio se não encontrar a coleção
      return null;
    }
  }

  Future<String?> getNextCollectionId(String currentId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT id FROM collections
      WHERE id > ?
      ORDER BY id ASC
      LIMIT 1
    ''', [currentId]);

    if (result.isNotEmpty) {
      return result.first['id'] as String;
    } else {
      // Retorna null se não houver próxima coleção
      return null;
    }
  }

  Future<String?> getPreviousCollectionId(String currentId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT id FROM collections
      WHERE id < ?
      ORDER BY id DESC
      LIMIT 1
    ''', [currentId]);

    if (result.isNotEmpty) {
      return result.first['id'] as String;
    } else {
      return null;
    }
  }
}
