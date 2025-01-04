import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../enum/page_list_type.dart';
import '../service/note_service.dart';
import '../widgets/notes_list.dart';

class Trash extends StatefulWidget {
  const Trash({super.key});

  @override
  State<Trash> createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  final PageListType _pageListType = PageListType.trash;
  List<Note> _notes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    _changeLoadingState();
    _notes = await NoteService().findDeleted();
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
        title: const Text("Trash"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? const Center(child: Text("Nothing..."))
          : NotesList(notes: _notes, reloadNotes: null, pageListType: _pageListType),
    );
  }
}
