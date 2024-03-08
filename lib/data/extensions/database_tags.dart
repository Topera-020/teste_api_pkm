import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/tag_models.dart';

extension PokemonTagExtension on PokemonDatabaseHelper {
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
  Future<void> associateTagWithCard(String cardId, String tagId) async {
    final db = await database;
    try {
      // Inserir na tabela card_tag_association
      await db.insert('card_tag_association', {
        'id': '${cardId}_$tagId',
        'card_id': cardId,
        'tag_id': tagId,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error associating tag with card: $e');
    }
  }

  // Desassocia uma tag de um cartão
  Future<void> disassociateTagFromCard(String cardId, String tagId) async {
    final db = await database;
    try {
        // Excluir da tabela card_tag_association
        await db.delete(
          'card_tag_association',
          where: 'id = ?',
          whereArgs: ['${cardId}_$tagId'],
        );
    } catch (e) {
      // ignore: avoid_print
      print('Error disassociating tag from card: $e');
    }
  }

  Future<void> initTags() async {
    final db = await database;
    List<String> initialTags = ['Tenho', 'Preciso'];

    for (String tagName in initialTags) {
      try {
        // Verifica se a tag já existe no banco de dados
        List<Map<String, dynamic>> existingTags = await db.query(
          'tags',
          where: 'name = ?',
          whereArgs: [tagName],
        );

        if (existingTags.isEmpty) {
          // Se a tag não existe, então a insere
          await db.insert('tags', {
            'name': tagName,
          });
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error inserting new tag: $e');
      }
    }
  }


  Future<void> getTagsForCard({required String cardId}) async {
    final db = await database;
    //print('Searting tags $cardId');
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT *
      FROM tags t
      JOIN card_tag_association cta ON t.id = cta.tag_id
      WHERE cta.card_id = ?
    ''', [cardId]);
    print(result);
  }

  Future<void> getAllTags() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT t.name
      FROM tags t
    ''');
    print(result);
  }

  // Função para obter e imprimir as tags
  Future<void> cardTagAssociate({required bool associated, required String cardId, required String tagId}) async {
    try {
      if (associated){
        await PokemonDatabaseHelper.instance.disassociateTagFromCard(cardId, tagId);
      } else{
        await PokemonDatabaseHelper.instance.associateTagWithCard(cardId, tagId);
      }
      //print('Tag alterada carta $cardId: $tagId = ${!associated}');
    } catch (e) {
      // ignore: avoid_print
      print('Erro alterar as tags da carta: $e');
    }
  }
  
}
