import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cripto.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_pokemonCards);
    await db.execute(_pokemonNames);
    await db.execute(_treinerNames);
    await db.execute(_energyNames);
    await db.execute(_cardsImages);
    await db.execute(_cardsArtImages);
    await db.execute(_sets);
    await db.execute(_colection);
    await db.execute(_tags);
    await db.execute(_typesImages);
  }

  
  
  String get _pokemonCards => '''
      CREATE TABLE IF NOT EXISTS Pokemon_Cards (
        id TEXT PRIMARY KEY,
        name TEXT,
        card_set TEXT,
        supertype TEXT,
        subtypes TEXT,
        hp INTEGER,
        types TEXT,
        ability_names TEXT,
        attack_names TEXT,
        number TEXT
      );
    ''';
  
  String get _pokemonNames => '''
      CREATE TABLE IF NOT EXISTS Pokemon_Names (
        name TEXT PRIMARY KEY,
        card_ids TEXT
      )
    ''';

  String get _treinerNames => '''
      CREATE TABLE IF NOT EXISTS Treiner_Names (
        name TEXT PRIMARY KEY,
        card_ids TEXT
      )
    ''';

    String get _energyNames => '''
        CREATE TABLE IF NOT EXISTS Energy_Names (
          name TEXT PRIMARY KEY,
          card_ids TEXT
        )
      ''';

    String get _cardsImages => '''
        CREATE TABLE IF NOT EXISTS Cards_Images ( 
          card_id TEXT PRIMARY KEY,
          image_data BLOB
        )
    ''';

    String get _cardsArtImages => '''
        CREATE TABLE IF NOT EXISTS Cards_art_Images ( 
            card_id TEXT PRIMARY KEY,
            image_data BLOB
        )
    ''';
    
    String get _sets => '''
        CREATE TABLE IF NOT EXISTS Sets (
            id TEXT PRIMARY KEY,
            set_name TEXT,
            series TEXT, 
            printedTotal INT, 
            total INT, 
            ptcgoCode TEXT, 
            releaseDate DATE, 
            Liga TEXT, 
            Symbol TEXT, 
            Logo TEXT
        )
    ''';

    String get _colection => '''
        CREATE TABLE IF NOT EXISTS Colection (
            id TEXT PRIMARY KEY,
            Temos BOOLEAN,
            Queremos BOOLEAN,
            Precisamos BOOLEAN
        )
    ''';

    String get _tags =>'''
        CREATE TABLE IF NOT EXISTS Tags (
            id TEXT PRIMARY KEY,
            tags TEXT 
        )
    ''';

    String get _typesImages =>'''
        CREATE TABLE IF NOT EXISTS Types_Images ( 
            Type TEXT PRIMARY KEY,
            image_data BLOB
        )
    ''';

}
