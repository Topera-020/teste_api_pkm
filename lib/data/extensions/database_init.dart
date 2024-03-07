import 'package:path/path.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

extension PokemonCardExtension on PokemonDatabaseHelper{
  Future<Database> initDatabase() async {
    // Obtém o caminho do banco de dados no dispositivo
    String path = join(await getDatabasesPath(), 'pokemon.db');
    
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
            numberINT INTEGER,
            FOREIGN KEY (collectionId) REFERENCES collections(id)
          )
        ''');

        // Tabela para armazenar todas as tags individuais
        await db.execute('''
          CREATE TABLE tags(
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');

        // Tabela para armazenar dados das listas de cartas do usuário
        await db.execute('''
          CREATE TABLE user_data(
            id TEXT PRIMARY KEY,
            tags TEXT,
            tenho INTEGER,
            preciso INTEGER,
            FOREIGN KEY (id) REFERENCES pokemon_cards(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE card_tag_association(
            id INTEGER PRIMARY KEY,
            card_id TEXT,
            tag_id TEXT,
            FOREIGN KEY (card_id) REFERENCES pokemon_cards(id),
            FOREIGN KEY (tag_id) REFERENCES tags(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE assets (
            name TEXT PRIMARY KEY,
            class TEXT,
            imageBase64 TEXT
          )
        ''');
      },
    );
  }
}