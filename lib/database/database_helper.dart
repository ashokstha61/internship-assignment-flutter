import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_book.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Database instance
  static Database? _database;

  // Initialize or return database instance
  Future<Database> get database async {
    // Handle multiple calls during async initialization
    if (_database != null) return _database!;

    try {
      // Initialize database
      _database = await _initDB();
    } catch (e) {
      print('Database initialization failed: $e');
      rethrow; // Propagate the error after logging it
    }

    // Null safety check
    if (_database == null) {
      throw Exception('Database initialization failed!');
    }

    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            title TEXT,
            authors TEXT,
            thumbnail TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE favorites ADD COLUMN thumbnail TEXT");
        }
      },
    );
  }

  Future<int> insertFavorite(FavoriteBook book) async {
    final db = await database;
    try {
      return await db.insert('favorites', book.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error inserting favorite: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
  try {
    final db = await database; // Ensure database is initialized properly
    if (db == null) {
      throw Exception('Database is not initialized'); // Defensive check
    }
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps; // Always returns a list
  } catch (e) {
    print('Error fetching favorites: $e');
    return []; // Return an empty list in case of error
  }
}


  Future<int> deleteFavorite(String id) async {
    final db = await database;
    try {
      return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting favorite: $e');
      return -1;
    }
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'favorites',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }
}
