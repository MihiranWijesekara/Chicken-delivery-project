import 'package:chicken_dilivery/Model/ItemModel.dart';
import 'package:chicken_dilivery/Model/RootModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chicken_delivery.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = kIsWeb ? filePath : join(await getDatabasesPath(), filePath);

    return await openDatabase(
      path,
      version: 2, // Increased version to trigger onUpgrade
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE roots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add roots table if upgrading from version 1
      await db.execute('''
        CREATE TABLE IF NOT EXISTS roots (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
      ''');
    }
  }

  // Insert item
  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return await db.insert('items', item.toMap());
  }

  // Insert root
  Future<int> insertRoot(RootModel root) async {
    final db = await database;
    return await db.insert('roots', root.toMap());
  }

  // Get all items
  Future<List<ItemModel>> getAllItems() async {
    final db = await database;
    final result = await db.query('items', orderBy: 'id ASC');
    return result.map((map) => ItemModel.fromMap(map)).toList();
  }

  // Get all roots
  Future<List<RootModel>> getAllRoots() async {
    final db = await database;
    final result = await db.query('roots', orderBy: 'id ASC');
    return result.map((map) => RootModel.fromMap(map)).toList();
  }

  // Update item
  Future<int> updateItem(ItemModel item) async {
    final db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // Update root
  Future<int> updateRoot(RootModel root) async {
    final db = await database;
    return await db.update(
      'roots',
      root.toMap(),
      where: 'id = ?',
      whereArgs: [root.id],
    );
  }

  // Delete item
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete root
  Future<int> deleteRoot(int id) async {
    final db = await database;
    return await db.delete(
      'roots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}