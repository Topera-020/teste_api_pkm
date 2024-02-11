import 'package:sqflite/sqflite.dart';
import 'package:teste_api/data/database.dart';
import 'package:teste_api/models/card_models.dart';

class PokemonRepository {
  late Database _db;

  Future<void> initializeDatabase() async {
    _db = await DB.instance.database;
  }

  Future<List<PokemonCard>> getPokemonCards(String query) async {
    final List<Map<String, dynamic>> cards = await _db.rawQuery(query);
    return List.generate(cards.length, (index) {
      return PokemonCard.fromMap(cards[index]);
    });
  }

  Future<void> addPokemonCard(PokemonCard card) async {
    await _db.insert('Pokemon_Cards', card.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updatePokemonCard(PokemonCard card) async {
    await _db.update(
      'Pokemon_Cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> deletePokemonCard(String cardId) async {
    await _db.delete(
      'Pokemon_Cards',
      where: 'id = ?',
      whereArgs: [cardId],
    );//quase não vai usar o delete
  }

  Future<int> getQuantidadeDeCartas() async {
    final List<Map<String, dynamic>> cards = await _db.rawQuery('SELECT COUNT(*) as count FROM Pokemon_Cards');
    final int quantidadeDeCartas = cards.isNotEmpty ? cards.first['count'] as int : 0;
    return quantidadeDeCartas;
  } 
}
