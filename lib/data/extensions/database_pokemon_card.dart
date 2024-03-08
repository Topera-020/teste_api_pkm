import 'dart:convert';

import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:sqflite/sqflite.dart';

// Método para inserir uma carta de Pokémon no banco de dados
extension PokemonCardExtension on PokemonDatabaseHelper {
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

  String mapOrderBy(String original) {
    switch (original) {
      case 'Data':
        return 'releaseDate';
      case 'Número':
        return 'numberINT';
      case 'Nome':
        return 'name';
      case '# Pokédex':
        return 'supertype';
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
      case 'Série':
        return 'series';
      case '# Cartas':
        return 'total';
      default:
        return original;
    }
  }

  Future<List<PokemonCard>?> getPokemonCards({
    String? collectionId,
    String primaryOrderByClause = 'releaseDate',
    String secondaryOrderByClause = 'numberINT',
    bool isAscending1 = true,
    bool isAscending2 = true,
    String? searchTerm,
  }) async {
    final db = await database;

    String whereClause = '';
    List<String> args = [];

    if (collectionId != null || searchTerm != null) {
      whereClause = 'WHERE ';
    }

    if (collectionId != null) {
      whereClause += "pc.collectionId = ?";
      args = [collectionId];
    }

    if (searchTerm != null) {
      if (collectionId != null) {
        whereClause += 'AND (';
      }

/*
      if (primaryOrderByClause == '# Pokédex') {
        print('Pokédex');
        whereClause += 'LOWER(pc.supertype) = ? AND ( ';
        args.add('pokémon');
      }
*/
      whereClause += '''
          pc.nationalPokedexNumbers LIKE ? OR
          LOWER(pc.rarity) LIKE ? OR
          LOWER(pc.name) LIKE ? OR
          LOWER(c.series) LIKE ? OR
          LOWER(pc.types) LIKE ?  OR
          LOWER(pc.artist) LIKE ? OR
          LOWER(pc.subtypes) LIKE ? OR
          LOWER(c.releaseDate) LIKE ? OR
          LOWER(collectionName) LIKE ? OR
          LOWER(t.name) LIKE ? 
      ''';

      /*
      if (primaryOrderByClause == '# Pokédex') {
        whereClause += ' )';
      }*/

      if (collectionId != null) {
        whereClause += ' )';
      }

      // Adiciona argumentos correspondentes aos placeholders
      args.addAll(List.generate(10, (_) => '%$searchTerm%'));
      print(args);
    }

    // Critério de ordenação
    primaryOrderByClause = getColumnPrefix(mapOrderBy(primaryOrderByClause));
    secondaryOrderByClause = getColumnPrefix(mapOrderBy(secondaryOrderByClause));

    // Ordem
    primaryOrderByClause += isAscending1 ? ' ASC' : ' DESC';
    secondaryOrderByClause += isAscending2 ? ' ASC' : ' DESC';

    // Monta a consulta SQL final
    String query = '''
      SELECT 
        pc.*, 
        c.releaseDate, 
        c.name AS collectionName, 
        c.series,
        GROUP_CONCAT(t.name, ', ') AS tags
      FROM 
        pokemon_cards pc
      JOIN 
        collections c ON pc.collectionId = c.id
      LEFT JOIN
        card_tag_association cta ON pc.id = cta.card_id
      LEFT JOIN
        tags t ON cta.tag_id = t.id
      $whereClause
      GROUP BY 
        pc.id
      ORDER BY 
        $primaryOrderByClause, 
        $secondaryOrderByClause
    ''';

    // Executa a consulta e mapeia diretamente para objetos PokemonCard
    List<Map<String, dynamic>> maps = await db.rawQuery(query, args);
    //print(maps.map((e) => ' ${e['name']}: ${e['tags']}'));
    return maps.map((map) => PokemonCard.fromMap(map)).toList();
  }
}
