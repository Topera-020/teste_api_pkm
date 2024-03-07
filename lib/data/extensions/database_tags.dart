// Método para adicionar uma tag a uma carta de Pokémon
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/tag_models.dart';

extension PokemonCardExtension on PokemonDatabaseHelper {
  // Adiciona uma nova tag
  Future<int> insertTag(Tag tag) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Inserir na tabela tags
        await txn.insert('tags', {'name': tag.name});
      });

      return 1; // Retorna 1 para indicar sucesso na inserção
    } catch (e) {
      // ignore: avoid_print
      print('Error inserting new Tag: $e');
      return -1; // Retorna um valor que indica falha na inserção
    }
  }

  // Associa a nova tag a um cartão
  Future<void> associateTagWithCard(String cardId, int tagId) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Inserir na tabela card_tag_association
        await txn.insert('card_tag_association', {
          'card_id': cardId,
          'tag_id': tagId,
        });
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error associating tag with card: $e');
    }
  }
}
