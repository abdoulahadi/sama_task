import 'package:sama_task/data/models/task.dart';
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
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        priority TEXT,
        color TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        dueDate TEXT,
        userId INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_actions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_type TEXT,
        task_id INTEGER,  
        task_data TEXT   
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        priority: TaskPriority.values.firstWhere(
          (e) => e.name == maps[i]['priority'],
          orElse: () => TaskPriority.low,
        ),
        color: maps[i]['color'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
        updatedAt: DateTime.parse(maps[i]['updatedAt']),
        dueDate: DateTime.parse(maps[i]['dueDate']),
        userId: maps[i]['userId'],
      );
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertPendingAction(String actionType, int? taskId, String taskData) async {
    final db = await database;
    await db.insert('pending_actions', {
      'action_type': actionType,
      'task_id': taskId,
      'task_data': taskData,
    });
  }

  Future<List<Map<String, dynamic>>> getPendingActions() async {
    final db = await database;
    return await db.query('pending_actions');
  }

  Future<void> deletePendingAction(int id) async {
    final db = await database;
    await db.delete('pending_actions', where: 'id = ?', whereArgs: [id]);
  }
}