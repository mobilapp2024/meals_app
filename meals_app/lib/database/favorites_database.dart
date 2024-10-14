import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesDatabase {
  static final FavoritesDatabase instance = FavoritesDatabase._init();

  static Database? _database;

  FavoritesDatabase._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY
      )
    ''');
  }

  Future<void> insertFavorite(String mealId) async {
    final db = await instance.database;

    await db.insert(
      'favorites',
      {'id': mealId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String mealId) async {
    final db = await instance.database;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [mealId],
    );
  }

  Future<List<String>> getFavorites() async {
    final db = await instance.database;

    final result = await db.query('favorites');
    return result.map((row) => row['id'] as String).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
