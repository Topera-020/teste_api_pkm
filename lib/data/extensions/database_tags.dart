// Método para adicionar uma tag a uma carta de Pokémon
import 'dart:convert';
import 'package:pokelens/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

extension PokemonCardExtension on PokemonDatabaseHelper{
  Future<void> addTag(String id, String tag) async {
    final db = await database;
    // Recupera a lista de tags existentes para a carta
    final List<String> existingTags = await getCardTags(id);

    // Adiciona a nova tag à lista
    existingTags.add(tag);

    // Atualiza o campo 'tags' na tabela 'user_data'
    await db.rawUpdate(
      'UPDATE user_data SET tags = ? WHERE id = ?',
      [jsonEncode(existingTags), id],
    );
  }

  // Método para obter IDs de cartas associadas a uma tag específica
  Future<List<String>> getCardIdsByTag(String tag) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_data',
      columns: ['id', 'tags'],
      where: '? IN (tags)',
      whereArgs: [tag],
    );

    final List<String> cardIds = [];
    for (final Map<String, dynamic> row in result) {
      final List<dynamic> tags = jsonDecode(row['tags'] ?? '[]');
      if (tags.contains(tag)) {
        cardIds.add(row['id']);
      }
    }

    return cardIds;
  }

  // Método para obter todas as tags únicas armazenadas no banco de dados
  Future<List<String>> getAllTags() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('user_data', columns: ['tags']);

    // Extrai todas as tags da tabela 'user_data'
    final List<String> allTags = [];
    for (final Map<String, dynamic> row in result) {
      final List<dynamic> tags = jsonDecode(row['tags'] ?? '[]');
      allTags.addAll(tags.cast<String>());
    }

    // Remove duplicatas usando um Set
    final Set<String> uniqueTags = Set<String>.from(allTags);

    return uniqueTags.toList();
  }

  // Método para obter as tags associadas a uma carta de Pokémon específica
  Future<List<String>> getCardTags(String cardId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_data',
      columns: ['tags'],
      where: 'id = ?',
      whereArgs: [cardId],
    );

    if (result.isEmpty) {
      // Se a carta não tiver entrada na tabela 'user_data', retorna uma lista vazia
      return [];
    }

    // Extrai tags da carta
    final List<dynamic> tags = jsonDecode(result.first['tags'] ?? '[]');

    return tags.cast<String>();
  }

  // Método para remover uma tag de uma carta de Pokémon
  Future<void> removeCardTag(String id, String tag) async {
    final db = await database;

    // Recupera a lista de tags existentes para a carta
    final List<String> existingTags = await getCardTags(id);

    // Remove a tag da lista
    existingTags.remove(tag);

    // Atualiza o campo 'tags' na tabela 'user_data'
    await db.rawUpdate(
      'UPDATE user_data SET tags = ? WHERE id = ?',
      [jsonEncode(existingTags), id],
    );
  }

  // Método para deletar uma tag do banco de dados
  Future<void> deleteTag(String tag, Database db) async {
    
    // Atualiza todas as cartas que têm a tag
    await db.rawUpdate(
      'UPDATE user_data SET tags = REPLACE(tags, ?, "") WHERE tags LIKE ?',
      [tag, '%$tag%'],
    );
    
    // Remove a tag da lista de tags
    await db.rawUpdate('UPDATE user_data SET tags = REPLACE(tags, ?, "")', [tag]);
  }
}