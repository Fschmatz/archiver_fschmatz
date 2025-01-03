import 'package:fluttertoast/fluttertoast.dart';

import '../dao/note_dao.dart';
import '../entity/note.dart';
import 'mongodb_service.dart';

class SyncService {
  final MongoDBService _mongoDb = MongoDBService();
  final dbNote = NoteDao.instance;

  Future<List<Note>> findAllNotes() async {
    await _mongoDb.connect();

    try {
      final notes = await _mongoDb.findAllNotes();

      return notes.isNotEmpty ? notes.map((map) => Note.fromMap(map)).toList() : [];
    } finally {
      await _mongoDb.disconnect();
    }
  }

  Future<void> insertNote(Note note) async {
    await _mongoDb.connect();

    try {
      await _mongoDb.insertNote(note.toMap());
    } finally {
      await _mongoDb.disconnect();
    }
  }

  Future<void> syncNotes() async {
    var resp = await dbNote.find();

    if (resp.isNotEmpty) {
      await _mongoDb.connect();

      try {
        await _mongoDb.syncNotes(resp);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      } finally {
        await _mongoDb.disconnect();
      }
    }
  }
}
