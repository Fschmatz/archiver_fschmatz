import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class NoteDao {

  static const _databaseName = "lync_sync.db";
  static const _databaseVersion = 1;

  static const String table = 'NOTES';
  static const String columnId = 'id';
  static const String columnText = 'text';
  static const String columnArchived = 'archived';
  static const String columnCreationDate = 'creationDate';
  static const String columnSynced = 'synced';
  static const String columnSyncDate = 'syncDate';
  static const String columnDeleted = 'deleted';
  static const String columnLastModifiedDate = 'lastModifiedDate';
  static const String columnLastModifiedDevice = 'lastModifiedDevice';
  static const String columnVersion = 'version';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  NoteDao._privateConstructor();
  static final NoteDao instance = NoteDao._privateConstructor();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId TEXT PRIMARY KEY,    
      $columnText TEXT,
      $columnArchived INTEGER NOT NULL,
      $columnCreationDate TEXT NOT NULL,
      $columnSynced INTEGER NOT NULL,
      $columnSyncDate TEXT,
      $columnDeleted INTEGER NOT NULL,
      $columnLastModifiedDate TEXT NOT NULL,
      $columnLastModifiedDevice TEXT NOT NULL,
      $columnVersion INTEGER NOT NULL
    )
  ''');
  }

  Future<List<Map<String, dynamic>>> find() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> findByArchivedValue(int archivedValue) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnArchived = $archivedValue ORDER BY id DESC');
  }

  Future<List<Map<String, dynamic>>> findByArchivedValueNotDeleted(int archivedValue) async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT * FROM $table 
      WHERE $columnArchived = $archivedValue
      AND   $columnDeleted = 0 
      ORDER BY id DESC    
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<List<Map<String, dynamic>>> findDeleted() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnDeleted = 1 ORDER BY id ASC');
  }

/*
  Future<List<Map<String, dynamic>>> getUnsyncedTexts() async {
    Database db = await instance.database;
    return await db.query('Texts', where: 'synced = ?', whereArgs: [0]);
  }

  Future<void> markTextAsSynced(int id) async {
    Database db = await instance.database;
    await db.update(
      'Texts',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> markNoteAsDeleted(String id) async {
    Database db = await instance.database;
    await db.update(
      table,
      {'deleted': 1, 'synced': 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> removeSyncedDeletedNotes() async {
    Database db = await instance.database;
    await db.delete(
      table,
      where: 'deleted = ? AND synced = ?',
      whereArgs: [1, 1],
    );
  }
*/

}
