import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._internal();
    return _databaseHelper!;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'restaurant.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE favorite_restaurants (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<int> insertFavoriteRestaurant(Map<String, dynamic> restaurant) async {
    Database db = await database;
    return await db.insert(
      'favorite_restaurants',
      restaurant,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteFavoriteRestaurant(String id) async {
    Database db = await database;
    return await db.delete(
      'favorite_restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteRestaurants() async {
    Database db = await database;
    return await db.query('favorite_restaurants');
  }
}
