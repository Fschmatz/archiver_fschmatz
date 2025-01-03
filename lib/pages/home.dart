import 'package:archiver_fschmatz/pages/settings/settings.dart';
import 'package:archiver_fschmatz/pages/store_note.dart';
import 'package:archiver_fschmatz/pages/trash.dart';
import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../service/note_service.dart';
import '../service/sync_service.dart';
import '../utils/app_details.dart';
import 'archive.dart';
import 'notes_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Note> _notes = [];
  bool _isLoading = false;
  bool _isSynchronizing = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    _changeLoadingState();
    _notes = await NoteService().findByArchivedValueNotDeleted(0);
    _changeLoadingState();
  }

  void _syncNotesWithMongo() async {
    _changeSynchronizingState();
    await SyncService().syncNotes();
    _changeSynchronizingState();
  }

  void _changeLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _changeSynchronizingState() {
    setState(() {
      _isSynchronizing = !_isSynchronizing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppDetails.appNameHomePage),
          actions: [
            IconButton(
              icon: const Icon(Icons.sync_outlined),
              onPressed: _syncNotesWithMongo,
            ),
            IconButton(
                icon: const Icon(Icons.archive_outlined),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Archive(),
                      ));
                }),
            IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Trash(),
                      ));
                }),
            IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Settings(),
                      ));
                }),
          ],
        ),
        body: Stack(
          children: [
            if (_isSynchronizing)
              const Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  bottom: true,
                  child: LinearProgressIndicator(),
                ),
              ),
            (_isLoading)
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                    ? const Center(child: Text("Nothing..."))
                    : NotesList(notes: _notes),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => StoreNote(
                    refreshHome: _loadNotes,
                    note: null,
                    isInsert: true,
                    isUpdate: false,
                  ),
                ));
          },
          child: const Icon(
            Icons.add_outlined,
          ),
        ));
  }
}
