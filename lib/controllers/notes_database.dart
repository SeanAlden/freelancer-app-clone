import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:clone_freelancer_mobile/models/notes.dart'; // import model Note

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE notes (
      id $idType,
      title $textType,
      content $textType
    )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = 'id ASC';
    final result = await db.query('notes', orderBy: orderBy);

    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// class NotesDatabase {
//   static final NotesDatabase instance = NotesDatabase._init();

//   static Database? _database;

//   NotesDatabase._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDB('notes.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const textType = 'TEXT NOT NULL';
//     const textNullable = 'TEXT';

//     await db.execute('''
//     CREATE TABLE notes (
//       id $idType,
//       userId $textType,
//       title $textType,
//       content $textNullable
//     )
//     ''');
//   }

//   Future<Note> create(Note note) async {
//     final db = await instance.database;

//     final id = await db.insert('notes', note.toMap());
//     return note.copyWith(id: id);
//   }

//   Future<List<Note>> readAllNotes(String userId) async {
//     final db = await instance.database;

//     final result = await db.query(
//       'notes',
//       columns: ['id', 'userId', 'title', 'content'],
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );

//     return result.map((json) => Note.fromMap(json)).toList();
//   }

//     Future<int> update(Note note) async {
//     final db = await instance.database;
//     return db.update(
//       'notes',
//       note.toMap(),
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//   }


//   Future<int> delete(int id) async {
//     final db = await instance.database;

//     return await db.delete(
//       'notes',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
