// database_helper.dart
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'chat_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        message TEXT,
        timestamp INTEGER,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ChatMessage operations
  Future<int> insertChatMessage(ChatMessage message) async {
    final db = await database;
    return await db.insert('chat_messages', message.toMap());
  }

  Future<List<ChatMessage>> getChatMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chat_messages');
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  Future<int> updateChatMessage(ChatMessage message) async {
    final db = await database;
    return await db.update('chat_messages', message.toMap(),
        where: 'id = ?', whereArgs: [message.id]);
  }

  Future<int> deleteChatMessage(int id) async {
    final db = await database;
    return await db.delete('chat_messages', where: 'id = ?', whereArgs: [id]);
  }
}
