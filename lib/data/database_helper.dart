// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PokemonDatabaseHelper {
  // Declaração da classe que gerencia o banco de dados SQLite para cartas de Pokémon e coleções

  // Instância única da classe para garantir uma única conexão ao banco de dados
  static Database? _database;  // Alterado para Database? para permitir nulos
  static final PokemonDatabaseHelper instance = PokemonDatabaseHelper._();

  // Construtor privado para garantir que a classe seja utilizada como singleton
  PokemonDatabaseHelper._();

  // Método getter assíncrono para obter a instância do banco de dados
  Future<Database> get database async {
    // Retorna a instância existente se já estiver inicializada
    if (_database != null) return _database!;

    // Caso contrário, inicializa o banco de dados e retorna a instância
    _database = await initDatabase();
    return _database!;
  }

  // Método privado para inicializar o banco de dados
  Future<Database> initDatabase() async {
    // Obtém o caminho do banco de dados no dispositivo
    String path = join(await getDatabasesPath(), 'pokemon.db');
    print(path);
    
    // Abre o banco de dados ou cria um novo se não existir
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Cria tabelas no banco de dados se não existirem

        // Tabela para armazenar dados de coleções
        await db.execute('''
          CREATE TABLE collections(
            id TEXT PRIMARY KEY,
            name TEXT,
            series TEXT,
            printedTotal INTEGER,
            total INTEGER,
            ptcgoCode TEXT,
            releaseDate TEXT,
            symbolImg TEXT,
            logoImg TEXT
          )
        '''); 

        // Tabela para armazenar dados de cartas de Pokémon
        await db.execute('''
          CREATE TABLE pokemon_cards(
            id TEXT PRIMARY KEY,
            name TEXT,
            small TEXT,
            large TEXT,
            supertype TEXT,
            subtypes TEXT,
            hp TEXT,
            types TEXT,
            convertedRetreatCost INTEGER,
            collectionId TEXT,
            number TEXT,
            artist TEXT,
            rarity TEXT,
            nationalPokedexNumbers TEXT,
            FOREIGN KEY (collectionId) REFERENCES collections(id)
          )
        ''');

        // Tabela para armazenar dados das listas de cartas do usuário
        await db.execute('''
          CREATE TABLE user_data(
            id TEXT PRIMARY KEY,
            tags TEXT,
            tenho BOOLEAN,
            preciso BOOLEAN,
            FOREIGN KEY (id) REFERENCES pokemon_cards(id)
          )
        ''');
      },
    );
  }

  // Método para adicionar uma tag a uma carta de Pokémon
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
  Future<void> deleteTag(String tag) async {
    final db = await database;
    
    // Atualiza todas as cartas que têm a tag
    await db.rawUpdate(
      'UPDATE user_data SET tags = REPLACE(tags, ?, "") WHERE tags LIKE ?',
      [tag, '%$tag%'],
    );
    
    // Remove a tag da lista de tags
    await db.rawUpdate('UPDATE user_data SET tags = REPLACE(tags, ?, "")', [tag]);
  }

  // Método para inserir uma carta de Pokémon no banco de dados
  Future<int> insertPokemonCard(PokemonCard card) async {
    final db = await database;
    // Verifica se o ID da coleção já existe
    final existingCard = await db.query(
      'pokemon_cards',
      where: 'id = ?',
      whereArgs: [card.id],
    );

    if (existingCard.isNotEmpty) {
      // O ID já existe; você pode lidar com isso conforme necessário
      print('Card with ID ${card.id} already exists.');
      return -1; // Ou algum outro valor para indicar falha
    }

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
        });

        // Inserir na tabela user_data (valores padrão)
        await txn.insert('user_data', {
          'id': card.id,
          'tags': '[]', // Valor padrão para tags
          'tenho': 0, // Valor padrão para tenho
          'preciso': 0, // Valor padrão para preciso
        });
      });

      return 1; // Retorna 1 para indicar sucesso na inserção
    } catch (e) {
      print('Error inserting PokemonCard: $e');
      return -1; // Retorna um valor que indica falha na inserção
    }
  }


  // Método para obter todas as cartas de Pokémon do banco de dados
  Future<List<PokemonCard>?> getPokemonCards({String? collectionId}) async {
    final db = await database;

    List<Map<String, dynamic>> maps;
    print('DB collectionId: $collectionId');

    if (collectionId != null) {
      maps = await db.rawQuery('''
        SELECT pc.*, c.releaseDate, c.name AS collectionName, c.series, ud.tags, ud.tenho, ud.preciso
        FROM pokemon_cards pc
        JOIN collections c ON pc.collectionId = c.id
        JOIN user_data ud ON pc.id = ud.id
        WHERE pc.collectionId = ?
      ''', [collectionId]);
    } else {
      maps = await db.rawQuery('''
        SELECT pc.*, c.releaseDate, c.name AS collectionName, c.series, ud.tags, ud.tenho, ud.preciso
        FROM pokemon_cards pc
        JOIN collections c ON pc.collectionId = c.id
        JOIN user_data ud ON pc.id = ud.id
      ''');
    }

    return List.generate(maps.length, (i) {
      PokemonCard card = PokemonCard.fromMap(maps[i]);
      return card;
    });
  }

  Future<List<Map<String, dynamic>>> listByCollectionId(String collectionId) async {
  try {
    final Database db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT collectionId, COUNT(*) as total FROM pokemon_cards WHERE collectionId = ? GROUP BY collectionId',
      [collectionId],
    );

    return result;
  } catch (e) {
    print('Erro ao contar cartões por collectionId: $e');
    return [];
  }
}

  // Método para inserir uma coleção no banco de dados
  Future<int> insertCollection(Collection collection) async {
    final db = await database;
    
    // Verifica se o ID da coleção já existe
    final existingCollection = await db.query(
      'collections',
      where: 'id = ?',
      whereArgs: [collection.id],
    );

    if (existingCollection.isNotEmpty) {
      // O ID já existe; você pode lidar com isso conforme necessário
      print('Collection with ID ${collection.id} already exists.');
      return -1; // Ou algum outro valor para indicar falha
    }

    try {
      // O ID não existe, prossegue com a inserção
      return await db.insert('collections', {
        'id': collection.id,
        'name': collection.name,
        'series': collection.series,
        'printedTotal': collection.printedTotal,
        'total': collection.total,
        'ptcgoCode': collection.ptcgoCode,
        'releaseDate': collection.releaseDate,
        'symbolImg': collection.symbolImg,
        'logoImg': collection.logoImg
      });
    } catch (e) {
      print('Error inserting Collection: $e');
      return -1; // Retorna um valor que indica falha na inserção
    }
  }

  // Método para obter todas as coleções do banco de dados
  Future<List<Collection>> getCollections() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('collections');
    return List.generate(maps.length, (i) {
      return Collection.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getAllCollectionTotal() async {
    try {
      final Database db = await instance.database;

      final List<Map<String, dynamic>> result = await db.query(
        'collections',
        columns: ['id', 'total'],
        orderBy: 'releaseDate DESC',
      );

      return result;
    } catch (e) {
      print('Erro ao obter todas as informações das coleções: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> countAllPokemonCardsByCollectionId() async {
    try {
      final Database db = await instance.database;

      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT collectionId, COUNT(*) as total FROM pokemon_cards GROUP BY collectionId',
      );

      return result;
    } catch (e) {
      print('Erro ao contar cartões por collectionId: $e');
      return [];
    }
  }



  
  // Método para contar o número de cartas de Pokémon no banco de dados
  Future<int> countPokemon() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM pokemon_cards');
    return Sqflite.firstIntValue(result) ?? 0;  // Retorna o número de registros na tabela
  }

  // Método para contar o número de coleções no banco de dados
  Future<int> countCollections() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM collections');
    return Sqflite.firstIntValue(result) ?? 0;  // Retorna o número de registros na tabela
  }

  // Método para exportar dados do banco de dados para arquivos CSV
  Future<void> exportToCSV() async {
    final db = await database;

    // Exporta dados da tabela 'pokemon_cards'
    final List<Map<String, dynamic>> pokemonCards = await db.query('pokemon_cards');
    final csvPokemonCards = List<List<dynamic>>.from(pokemonCards.map((card) => card.values.toList()));
    csvPokemonCards.insert(0, pokemonCards[0].keys.toList());

    final pokemonCardsFile = File('pokemon_cards.csv');
    await pokemonCardsFile.writeAsString(csvPokemonCards.map((row) => row.join(',')).join('\n'));

    // Exporta dados da tabela 'collections'
    final List<Map<String, dynamic>> collections = await db.query('collections');
    final csvCollections = List<List<dynamic>>.from(collections.map((collection) => collection.values.toList()));
    csvCollections.insert(0, collections[0].keys.toList());

    final collectionsFile = File('collections.csv');
    await collectionsFile.writeAsString(csvCollections.map((row) => row.join(',')).join('\n'));

    print('Exportação para CSV concluída.');
  }


}
