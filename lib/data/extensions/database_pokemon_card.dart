import 'dart:convert';

import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:sqflite/sqflite.dart';

// Método para inserir uma carta de Pokémon no banco de dados
extension PokemonCardExtension on PokemonDatabaseHelper{

  Future<int> insertPokemonCard(PokemonCard card) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Inserir na tabela pokemon_cards
        await txn.insert('pokemon_cards', {
          'id': card.id,
          'name': card.name,
          'small': card.small,
          'large': card.large,
          'supertype': card.supertype,
          'subtypes': jsonEncode(card.subtypes),
          'hp': card.hp,
          'types': jsonEncode(card.types),
          'convertedRetreatCost': card.convertedRetreatCost,
          'collectionId': card.collectionId,
          'number': card.number,
          'artist': card.artist,
          'rarity': card.rarity,
          'nationalPokedexNumbers': jsonEncode(card.nationalPokedexNumbers),
          'numberINT': card.numberINT
        });
      });

      return 1; // Retorna 1 para indicar sucesso na inserção
    } catch (e) {
        if (e is DatabaseException &&
            e.isUniqueConstraintError('pokemon_cards.id')) {
          // Tratamento específico para violação de chave única
          // ignore: avoid_print
          print('Erro: Já existe um Pokémon com o mesmo ID.');
        } else {
          // Outro tratamento de erro genérico
          // ignore: avoid_print
          print('Erro ao inserir PokemonCard: $e');
        }
        return -1; // Retorna um valor que indica falha na inserção
      }
  }
  
  String mapOrderBy(String original) {
    switch (original) {
      case 'Data':
        return 'releaseDate';
      case 'Número':
        return 'numberINT';
      case 'Nome':
        return 'name';
      case '# Pokédex':
        return 'nationalPokedexNumbers';
      case 'Artista':
        return 'artist';
      case 'Raridade':
        return 'rarity';
      case 'Tipo':
        return 'types';
      case 'Hp':
        return 'hp';
      case 'Sub-categoria':
        return 'subtypes';
      case 'Super-Categoria':
        return 'supertype';

      default:
        return original;
    }
  }

  String getColumnPrefix(String columnName) {
    switch (columnName) {
      case 'collectionName':
      case 'tags':
        return columnName; // AS

      case 'releaseDate':
      case 'series':
        return 'c.$columnName';

      default:
        return 'pc.$columnName';
    }
  }

  Future<List<PokemonCard>?> getPokemonCards({
    //collection id para Todas, vai receber mais coisa
    //(nesse caso vai se tornar um campo de filtro individual)
    List<String>? collectionId,

    //campos de filtro individual
    //listas
    List<String>? seriesSearch,
    List<String>? subclassSearch,
    List<String>? tipoSearch,
    List<String>? artistSearch,

    //específico texto like
    List<String>? nameSearch,

    //numero
    List<String>? numberSearch,
    List<int>? pokedexSearch,
    List<int>? hpSearch,
    List<int>? retreatSearch,

    //pesquisa geral
    String? searchTerm,
    String? filterColumn,
    bool? isAscending1,
    bool? isAscending2,

    //fazer listas e case switch
    String primaryOrderByClause = 'c.releaseDate',
    String secundaryOrderByClause = 'pc.numberINT',
  }) async {
    final db = await database;

    primaryOrderByClause = mapOrderBy(primaryOrderByClause);
    secundaryOrderByClause = mapOrderBy(secundaryOrderByClause);

    // Monta a cláusula WHERE baseada no searchTerm e filterColumn
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null) {
      whereClause = '''
        LOWER(name) LIKE ? 
        OR LOWER(supertype) LIKE ? 
        OR LOWER(subtypes) LIKE ? 
        OR hp LIKE ? 
        OR LOWER(types) LIKE ? 
        OR number = ? 
        OR LOWER(artist) LIKE ? 
        OR LOWER(rarity) LIKE ?
        OR nationalPokedexNumbers = ? 
        OR numberINT = ?
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
      if (seriesSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'printedTotal = ? ';
        whereArgs.add(seriesSearch);
      }
      if (nameSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'total = ? ';
        whereArgs.add(nameSearch);
      }
      if (numberSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(ptcgoCode) LIKE ? ';
        whereArgs.add('%$numberSearch%');
      }
      if (pokedexSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$pokedexSearch%');
      }
      if (subclassSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$subclassSearch%');
      }
      if (tipoSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$tipoSearch%');
      }
      if (hpSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$hpSearch%');
      }
      if (artistSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$artistSearch%');
      }
      if (retreatSearch != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$retreatSearch%');
      }
      if (collectionId != null) {
        whereClause += whereClause.isNotEmpty ? 'AND ' : '';
        whereClause += 'LOWER(releaseDate) LIKE ? ';
        whereArgs.add('%$collectionId%');
      }

    }

    // Monta a cláusula ORDER BY baseada na ordenação e na direção
    String orderClause = '$primaryOrderByClause ${isAscending1 != null ? (isAscending1 ? 'ASC' : 'DESC') : 'DESC'}, '
        '$secundaryOrderByClause ${isAscending2 != null ? (isAscending2 ? 'ASC' : 'DESC') : 'DESC'}';

    // Monta a consulta SQL final
    String query = '''
      SELECT pc.*, c.releaseDate, c.name AS collectionName, c.series, GROUP_CONCAT(t.name) AS tags
      FROM pokemon_cards pc
      JOIN collections c ON pc.collectionId = c.id
      LEFT JOIN card_tag_association cta ON pc.id = cta.card_id
      LEFT JOIN tags t ON cta.tag_id = t.id
      ${whereClause.isNotEmpty ? 'WHERE $whereClause' : ''}
      ORDER BY $primaryOrderByClause, $secundaryOrderByClause
    ''';

 
    // Executa a consulta e mapeia diretamente para objetos PokemonCard
    List<Map<String, dynamic>> maps = await db.rawQuery(query, whereArgs);
    return maps.map((map) => PokemonCard.fromMap(map)).toList();
  }
  

}