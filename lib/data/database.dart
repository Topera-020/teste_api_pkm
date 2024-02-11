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

  

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_pokemonCards);
    await db.execute(_collections);
    await db.execute(_typesImages);
    await db.execute(_tags);
    await db.execute(_configurations);
    await db.execute(_pokedex);
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
        number TEXT,
        variants TEXT,
        owned BOOLEAN,
        need BOOLEAN
      );
    ''';

  String get _collections => '''
        CREATE TABLE IF NOT EXISTS Sets (
            id TEXT PRIMARY KEY,
            set_name TEXT,
            series TEXT, 
            printedTotal INT, 
            total INT, 
            ptcgoCode TEXT, 
            releaseDate TEXT, 
            liga TEXT, 
            symbol TEXT, 
            logo TEXT
        );
    ''';
  String get _pokedex => '''
        CREATE TABLE IF NOT EXISTS Pokedex (
            
        );
    ''';

  String get _typesImages => '''
        CREATE TABLE IF NOT EXISTS Types_Images ( 
            Type TEXT PRIMARY KEY,
            image_data BLOB
        );
    ''';

  String get _tags => '''
        CREATE TABLE IF NOT EXISTS tags ( 
            id INTEGER PRIMARY KEY,
            nome TEXT,
            iconIdentifier TEXT
        );
    ''';

  String get _configurations => '''
        CREATE TABLE IF NOT EXISTS configurations ( 
            name TEXT PRIMARY KEY,
            state BOOLEAN
        );
    ''';

  
  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'PokemonCards.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }
}
