import 'package:path/path.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';

extension PokemonCardExtension on PokemonDatabaseHelper {
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
             id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        // Tabela para armazenar a associação entre cartas e tags
        await db.execute('''
          CREATE TABLE card_tag_association(
            id TEXT PRIMARY KEY,
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

        await db.execute('''
          CREATE TABLE pokedex_species (
            species_id INT PRIMARY KEY,   
            order NUMBER,         
            pokemon_name TEXT,
            generation_name TEXT,
            is_baby NUMBER,
            is_legendary NUMBER,
            is_mythical NUMBER,
            evolves_from_species_id NUMBER,
            FOREIGN KEY (evolves_from_species_id) REFERENCES pokedex_species(species_id)
          )
        ''');

        await db.execute('''
          CREATE TABLE pokedex_varieties (
            varieties_id TEXT PRIMARY KEY,
            varieties_name TEXT,
            species_id TEXT,
            image_url TEXT,
            is_default NUMBER,
            is_shyne NUMBER,
            is_female NUMBER,
            FOREIGN KEY (species_id) REFERENCES pokedex_species(species_id)
          )
        ''');

        await db.execute('''
          CREATE TABLE pokedex_association (
            id TEXT PRIMARY KEY,
            card_id TEXT,
            pokemon_id TEXT
            FOREIGN KEY (card_id) REFERENCES pokemon_cards(id),
            FOREIGN KEY (pokemon_id) REFERENCES pokedex_species(id)
          )
        ''');
      },
    );
  }
}
