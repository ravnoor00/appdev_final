import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'models/question.dart';
import 'models/notes.dart';

class DatabaseHelper {
  static const _databaseName = 'user_questions.db';
  static const _databaseVersion = 1;
  static const table1 = 'questions';
  static const columnName = 'name';
  static const columnQuestions = 'JSON_questions';
  static const columnBookmarked = 'bookmarked';
  static const columnTopic = 'topic';

  static const table2 = 'notes';
  static const columnNotesName = 'name';
  static const columnNotesQuestions = 'JSON_questions';
  static const columnNotesTopic = 'topic';
  static const columnNotes = '';

  // Singleton instance
  static DatabaseHelper? _instance;
  factory DatabaseHelper() {
    return _instance ??= DatabaseHelper._internal();
  }

  DatabaseHelper._internal();

  // SQLite database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table1 (
      $columnName TEXT NOT NULL,
      $columnQuestions TEXT NOT NULL,
      $columnBookmarked INTEGER NOT NULL,
      $columnTopic TEXT NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE $table2 (
      $columnNotesName TEXT NOT NULL,
      $columnNotesQuestions TEXT NOT NULL,
      $columnNotesTopic TEXT NOT NULL
      $columnNotes TEXT NOT NULL
    )
  ''');
  }

  Future<int> insertList(QuestionsList questionsList) async {
    Database? db = await database;
    final jsonString = jsonEncode(questionsList.questions);
    final row = {
      columnName: questionsList.name,
      columnQuestions: jsonString,
      columnBookmarked:
          questionsList.isBookmarked ? 1 : 0, // Convert bool to int
      columnTopic: questionsList.topic,
    };
    return await db!.insert(table1, row);
  }

  Future<int> insertNotes(Notes note) async {
    Database? db = await database;
    insertList(note.questions!);
    final row = {
      columnNotesName: note.name,
      columnQuestions: note.questions?.name ?? '',
      columnNotesTopic: note.topic,
      columnNotes: note.notes
    };
    return await db!.insert(table2, row);
  }

  Future<List<String>> getAllTopics() async {
    Database? db = await database;

    List<Map<String, dynamic>> result = await db!.query(
      table1,
      columns: [columnTopic],
      groupBy: columnTopic,
    );

    return result.map((row) => row[columnTopic] as String).toList();
  }

  Future<List<QuestionsList>> queryByTopic(String topic) async {
    Database? db = await database;
    String? whereClause = '$columnTopic = ?';
    List<dynamic>? whereArgs = [topic];

    List<Map<String, dynamic>> result =
        await db!.query(table1, where: whereClause, whereArgs: whereArgs);
    return result.map((row) {
      final questions = (jsonDecode(row[columnQuestions]) as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      final name = row[columnName] as String;
      final bookmarked = row[columnBookmarked] == 1; // Convert int to bool
      final topic = row[columnTopic] as String;
      return QuestionsList(questions, name, bookmarked, topic);
    }).toList();
  }

  Future<List<QuestionsList>> queryAllRows() async {
    Database? db = await database;
    List<Map<String, dynamic>> result = await db!.query(table1);
    return result.map((row) {
      final questions = (jsonDecode(row[columnQuestions]) as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      final name = row[columnName] as String;
      final bookmarked = row[columnBookmarked] == 1; // Convert int to bool
      final topic = row[columnTopic] as String;
      return QuestionsList(questions, name, bookmarked, topic);
    }).toList();
  }

  Future<List<QuestionsList>> queryAllBookMarked() async {
    Database? db = await database;
    String? whereClause = '$columnBookmarked = ?';
    List<dynamic>? whereArgs = [1];

    List<Map<String, dynamic>> result =
        await db!.query(table1, where: whereClause, whereArgs: whereArgs);
    return result.map((row) {
      final questions = (jsonDecode(row[columnQuestions]) as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      final name = row[columnName] as String;
      final bookmarked = row[columnBookmarked] == 1; // Convert int to bool
      final topic = row[columnTopic] as String;
      return QuestionsList(questions, name, bookmarked, topic);
    }).toList();
  }

  Future<void> updateBookmarkedStatus(String name, bool isBookmarked) async {
    Database? db = await database;
    await db!.update(
      table1,
      {columnBookmarked: isBookmarked ? 1 : 0},
      where: '$columnName = ?',
      whereArgs: [name],
    );
  }

  Future<void> deleteRow(String name) async {
    Database? db = await database;
    await db!.delete(table1, where: '$columnName = ?', whereArgs: [name]);
  }

  Future<void> deleteNote(String name) async {
    Database? db = await database;
    await db!.delete(table2, where: '$columnNotesName = ?', whereArgs: [name]);
    await db.delete(table1, where: '$columnName = ?', whereArgs: [name]);
  }

  Future<void> updateName(String oldName, String newName) async {
    Database? db = await database;
    await db!.update(
      table1,
      {columnName: newName},
      where: '$columnName = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> updateNote(String saved, String name) async {
    Database? db = await database;
    await db!.update(table2, {columnNotes: saved},
        where: '$columnNotesName = ?', whereArgs: [name]);
  }

  Future<bool> isNameExist(String name) async {
    Database? db = await database;
    List<Map<String, dynamic>> result =
        await db!.query(table1, where: '$columnName = ?', whereArgs: [name]);

    return result.isNotEmpty;
  }
}

List<Map<String, dynamic>> stringtoJSON(String reply) {
  RegExp jsonSeparatorPattern = RegExp(r'}\s*,\s*{');
  List<String> jsonStrings = reply.split(jsonSeparatorPattern);

  List<Map<String, dynamic>> jsonObjects = [];

  for (String jsonStr in jsonStrings) {
    if (!jsonStr.startsWith('{')) {
      jsonStr = '{$jsonStr';
    }
    if (!jsonStr.endsWith('}')) {
      jsonStr = '$jsonStr}';
    }

    Map<String, dynamic> jsonObject = jsonDecode(jsonStr);
    jsonObjects.add(jsonObject);
  }
  return jsonObjects;
}
