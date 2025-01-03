import '../dao/note_dao.dart';
import '../entity/note.dart';

class NoteService {
  final dbNote = NoteDao.instance;

  Future<List<Note>> findByArchivedValue(int archivedValue) async {
    var resp = await dbNote.findByArchivedValue(archivedValue);

    return resp.isNotEmpty ? resp.map((map) => Note.fromMap(map)).toList() : [];
  }

  Future<List<Note>> findByArchivedValueNotDeleted(int archivedValue) async {
    var resp = await dbNote.findByArchivedValueNotDeleted(archivedValue);

    return resp.isNotEmpty ? resp.map((map) => Note.fromMap(map)).toList() : [];
  }

  Future<List<Note>> findDeleted() async {
    var resp = await dbNote.findDeleted();

    return resp.isNotEmpty ? resp.map((map) => Note.fromMap(map)).toList() : [];
  }

  void insert(Note note) async {
    Map<String, dynamic> row = note.toMap();

    await dbNote.insert(row);
  }

  void update(Note note) async {
    Map<String, dynamic> row = {
      NoteDao.columnId: note.id,
      NoteDao.columnText: note.text
      /*,
      NoteDao.columnArchived: note.archived,
      NoteDao.columnCreationDate: note.creationDate*/
    };

    await dbNote.update(row);
  }

  void delete(int idNote) async {
    await dbNote.delete(idNote);
  }

  void softDelete(Note note) async {
    note.deleted = 1;

    await dbNote.update(note.toMap());
  }

  void unarchiveNote(Note note) async {
    note.archived = 0;

    await dbNote.update(note.toMap());
  }

  void archiveNote(Note note) async {
    note.archived = 1;

    await dbNote.update(note.toMap());
  }

  Future<List<Map<String, dynamic>>> findAllNotes() {
    return dbNote.find();
  }

  Future<void> deleteAllNotes() async {
    await dbNote.deleteAll();
  }

  Future<void> insertNotesFromRestoreBackup(List<dynamic> jsonData) async {
    for (dynamic item in jsonData) {
      await _insertNoteFromBackup(Note.fromMap(item));
    }
  }

  Future<void> _insertNoteFromBackup(Note note) async {
    Map<String, dynamic> row = {
      NoteDao.columnText: note.text,
      NoteDao.columnArchived: note.archived,
      NoteDao.columnCreationDate: note.creationDate
    };

    await dbNote.insert(row);
  }
}
