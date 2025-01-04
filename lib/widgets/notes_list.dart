import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../enum/page_list_type.dart';
import 'note_card.dart';

class NotesList extends StatefulWidget {
  final List<Note> notes;
  final PageListType pageListType;
  final Function()? reloadNotes;

  const NotesList({super.key, required this.notes, required this.pageListType, this.reloadNotes});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 8,
        ),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.notes.length,
        itemBuilder: (context, int index) {
          Note note = widget.notes[index];

          return NoteCard(
            key: UniqueKey(),
            note: note,
            reloadNotes: widget.reloadNotes,
            pageListType: widget.pageListType,
          );

        },
      ),
    );
  }
}
