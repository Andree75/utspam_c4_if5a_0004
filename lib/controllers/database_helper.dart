import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('apotek_uisi.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      fullName TEXT NOT NULL,
      email TEXT NOT NULL,
      phoneNumber TEXT NOT NULL,
      address TEXT NOT NULL,
      username TEXT NOT NULL,
      password TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      medicineName TEXT NOT NULL,
      price INTEGER NOT NULL,
      quantity INTEGER NOT NULL,
      totalPrice INTEGER NOT NULL,
      date TEXT NOT NULL,
      type TEXT NOT NULL,
      recipeNumber TEXT
    )
    ''');
  }

  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> insertTransaction(TransactionModel trans) async {
    final db = await instance.database;
    return await db.insert('transactions', trans.toMap());
  }

  Future<List<TransactionModel>> getTransactions(String username) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'id DESC',
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTransaction(TransactionModel trans) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      trans.toMap(),
      where: 'id = ?',
      whereArgs: [trans.id],
    );
  }
}
