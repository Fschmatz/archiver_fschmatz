import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../enum/page_list_type.dart';
import '../service/note_service.dart';
import '../widgets/notes_list.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  final PageListType _pageListType = PageListType.archive;
  List<Note> _notes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    _changeLoadingState();
    _notes = await NoteService().findByArchivedValueNotDeleted(1);
    _changeLoadingState();
  }

  void _changeLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archive"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
              ? const Center(child: Text("Nothing..."))
              : NotesList(notes: _notes, reloadNotes: _loadNotes, pageListType: _pageListType,),
    );
  }
}
