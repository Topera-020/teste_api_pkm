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

  // Método para obter todas as cartas de Pokémon do banco de dados
  Future<List<PokemonCard>?> getPokemonCards({String? collectionId}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (collectionId != null) {
      maps = await db.rawQuery('''
        SELECT pc.*, c.releaseDate, c.name AS collectionName, c.series, GROUP_CONCAT(t.name) AS tags
        FROM pokemon_cards pc
        JOIN collections c ON pc.collectionId = c.id
        LEFT JOIN card_tag_association cta ON pc.id = cta.card_id
        LEFT JOIN tags t ON cta.tag_id = t.id
        WHERE pc.collectionId = ?
        GROUP BY pc.id
        ORDER BY pc.numberINT ASC
      ''', [collectionId]);
    } else {
      maps = await db.rawQuery('''
        SELECT pc.*, c.releaseDate, c.name AS collectionName, c.series, GROUP_CONCAT(t.name) AS tags
        FROM pokemon_cards pc
        JOIN collections c ON pc.collectionId = c.id
        LEFT JOIN card_tag_association cta ON pc.id = cta.card_id
        LEFT JOIN tags t ON cta.tag_id = t.id
        GROUP BY pc.id
        ORDER BY pc.numberINT ASC
      ''');
    }

    return List.generate(maps.length, (i) {
      PokemonCard card = PokemonCard.fromMap(maps[i]);
      return card;
    });
  }

}