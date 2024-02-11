import 'package:sqflite/sqflite.dart';
import 'package:teste_api/data/database.dart';
import 'package:teste_api/models/card_models.dart';
import 'package:teste_api/models/collections_models.dart';

class CollectionsRepository {
  late Database _db;

  Future<void> initializeDatabase() async {
    _db = await DB.instance.database;
  }

  Future<List<PokemonCard>> getSets(String query) async {
    final List<Map<String, dynamic>> sets = await _db.rawQuery(query);
    return List.generate(sets.length, (index) {
      return PokemonCard.fromMap(sets[index]);
    });
  }

  Future<void> addSet(Collection collection) async {
    await _db.insert('Sets', collection.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateSet(Collection collection) async {
    await _db.update(
      'Sets',
      collection.toMap(),
      where: 'id = ?',
      whereArgs: [collection.id],
    );
  }

  Future<void> deleteSet(String setId) async {
    await _db.delete(
      'Sets',
      where: 'id = ?',
      whereArgs: [setId],
    );
  }

  Future<int> getQuantidadeDeSets() async {
    final List<Map<String, dynamic>> sets = await _db.rawQuery('SELECT COUNT(*) as count FROM Sets');
    final int quantidadeDeSets = sets.isNotEmpty ? sets.first['count'] as int : 0;
    return quantidadeDeSets;
  }
}
