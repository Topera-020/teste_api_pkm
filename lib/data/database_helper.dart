// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PokemonDatabaseHelper {
  static Database? _database;  // Alterado para Database? para permitir nulos
  static final PokemonDatabaseHelper instance = PokemonDatabaseHelper._();

  PokemonDatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'pokemon.db');
    print(path);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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
            setId TEXT,
            number TEXT,
            artist TEXT,
            rarity TEXT,
            nationalPokedexNumbers TEXT
          )
        ''');

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
      },
    );
  }

  Future<int> insertPokemonCard(PokemonCard card) async {
    final db = await database;
    try {
      return await db.insert('pokemon_cards', {
        'id': card.id,
        'name': card.name,
        'small': card.small,
        'large': card.large,
        'supertype': card.supertype,
        'subtypes': jsonEncode(card.subtypes),
        'hp': card.hp,
        'types': jsonEncode(card.types),
        'convertedRetreatCost': card.convertedRetreatCost,
        'setId': card.setId,
        'number': card.number,
        'artist': card.artist,
        'rarity': card.rarity,
        'nationalPokedexNumbers': jsonEncode(card.nationalPokedexNumbers),
      });
    } catch (e) {
      print('Error inserting PokemonCard: $e');
      return -1; // Retornar um valor que indique falha na inserção
    }
  }

  Future<List<PokemonCard>> getPokemonCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pokemon_cards');
    return List.generate(maps.length, (i) {
      return PokemonCard.fromMap(maps[i]);
    });
  }

  Future<int> insertCollection(Collection collection) async {
    final db = await database;
    try {
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
      return -1; // Retornar um valor que indique falha na inserção
    }
  }
  
  Future<List<Collection>> getCollections() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('collections');
    return List.generate(maps.length, (i) {
      return Collection.fromMap(maps[i]);
    });
  }
  
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'pokemon.db');
    var file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('Database deleted.');
    } else {
      print('Database not found at path: $path');
    }
  }

  Future<int> countPokemon() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM pokemon_cards');
    return Sqflite.firstIntValue(result) ?? 0;  // Retorna o número de registros na tabela
  }

  Future<int> countCollections() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM collections');
    return Sqflite.firstIntValue(result) ?? 0;  // Retorna o número de registros na tabela
  }

}
