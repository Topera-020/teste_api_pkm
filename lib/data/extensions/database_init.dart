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

  Future<int> insertUserData(String id) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        // Inserir na tabela user_data (valores padrão)
        await txn.insert('user_data', {
          'id': id,
          'tags': '[]', // Valor padrão para tags
          'tenho': 0, // Valor padrão para tenho
          'preciso': 0, // Valor padrão para preciso
        });
      });

      return 1; // Retorna 1 para indicar sucesso na inserção
    } catch (e) {
      // ignore: avoid_print
      print('Error inserting user_data: $e');
      return -1; // Retorna um valor que indica falha na inserção
    }
  }
}