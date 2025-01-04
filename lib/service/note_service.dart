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

  Future<void> insert(Note note) async {
    Map<String, dynamic> row = note.toMap();

    await dbNote.insert(row);
  }

  Future<void> update(Note note) async {
    await dbNote.update(note.toMap());
  }

  Future<void> delete(int idNote) async {
    await dbNote.delete(idNote);
  }

  Future<void> softDelete(Note note) async {
    note.deleted = 1;

    await update(note);
  }

  Future<void> unarchiveNote(Note note) async {
    note.archived = 0;

    await update(note);
  }

  Future<void> archiveNote(Note note) async {
    note.archived = 1;

    await update(note);
  }

  Future<List<Map<String, dynamic>>> findAllNotes() {
    return dbNote.find();
  }

  Future<void> deleteAllNotes() async {
    await dbNote.deleteAll();
  }

  Future<void> insertNotesFromRestoreBackup(List<dynamic> jsonData) async {
    List<Map<String, dynamic>> listToInsert = jsonData.map((item) {
      return Note.fromMap(item).toMap();
    }).toList();

    await dbNote.insertBatchForBackup(listToInsert);
  }

}
