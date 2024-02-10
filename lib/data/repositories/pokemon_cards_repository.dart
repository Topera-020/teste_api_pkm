import 'package:sqflite/sqflite.dart';
import 'package:teste_api/data/database.dart';
import 'package:teste_api/models/card_models.dart';

class CollectionsRepository {
  late Database _db;

  Future<void> initializeDatabase() async {
    _db = await DB.instance.database;
  }

  Future<List<PokemonCard>> getPokemonCards() async {
    final List<Map<String, dynamic>> cards = await _db.query('Pokemon_Cards');
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
    );
  }
}
