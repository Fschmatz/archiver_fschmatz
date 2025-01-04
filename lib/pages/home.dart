import 'package:archiver_fschmatz/pages/settings/settings.dart';
import 'package:archiver_fschmatz/pages/store_note.dart';
import 'package:archiver_fschmatz/pages/trash.dart';
import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../enum/page_list_type.dart';
import '../service/note_service.dart';
import '../service/sync_service.dart';
import '../utils/app_details.dart';
import 'archive.dart';
import '../widgets/notes_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageListType _pageListType = PageListType.home;
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
            PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert_outlined),
                itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                      const PopupMenuItem<int>(value: 0, child: Text('Sync with Mongo')),
                      const PopupMenuItem<int>(value: 1, child: Text('Archive')),
                      const PopupMenuItem<int>(value: 2, child: Text('Trash')),
                      const PopupMenuItem<int>(value: 3, child: Text('Settings')),
                    ],
                onSelected: (int value) {
                  switch (value) {
                    case 0:
                      _syncNotesWithMongo();
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Archive(),
                          ));
                      break;
                    case 2:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Trash(),
                          ));
                      break;
                    case 3:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Settings(
                              reloadNotes: _loadNotes,
                            ),
                          ));
                  }
                })
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
                    : NotesList(notes: _notes, reloadNotes: _loadNotes, pageListType: _pageListType),
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
