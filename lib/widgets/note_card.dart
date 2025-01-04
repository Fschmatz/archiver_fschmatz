import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../entity/note.dart';
import '../enum/page_list_type.dart';
import '../pages/store_note.dart';
import '../service/note_service.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function()? reloadNotes;
  final PageListType pageListType;

  const NoteCard({super.key, required this.note, this.reloadNotes, required this.pageListType});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final NoteService _noteService = NoteService();
  bool _isHomePage = false;
  bool _isArchivePage = false;
  bool _isTrashPage = false;

  @override
  void initState() {
    super.initState();

    _isHomePage = widget.pageListType == PageListType.home;
    _isArchivePage = widget.pageListType == PageListType.archive;
    _isTrashPage = widget.pageListType == PageListType.trash;
  }

  bool isNotTrashPage(){
    return !_isTrashPage;
  }

  Future<void> _softDeleteNote() async {
    _noteService.softDelete(widget.note);
  }

  Future<void> _archiveNote() async {
    _noteService.archiveNote(widget.note);
  }

  Future<void> _unarchiveNote() async {
    _noteService.unarchiveNote(widget.note);
  }

  void openEditPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => StoreNote(
            refreshHome: widget.reloadNotes!,
            note: widget.note,
            isInsert: false,
            isUpdate: true,
          ),
        ));
  }

  void openBottomMenu() {
    bool notArchived = widget.note.archived == 0;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      "Created at: ",
                    ),
                    trailing: Text(widget.note.formattedCreationDate, style: const TextStyle(fontSize: 14)),
                  ),
                  const Divider(),
                  Visibility(
                    visible: isNotTrashPage(),
                    child: ListTile(
                      leading: notArchived ? const Icon(Icons.archive_outlined) : const Icon(Icons.unarchive_outlined),
                      title: notArchived
                          ? const Text(
                              "Archive",
                            )
                          : const Text(
                              "Unarchive",
                            ),
                      onTap: () {
                        if (notArchived) {
                          _archiveNote();
                        } else {
                          _unarchiveNote();
                        }

                        widget.reloadNotes!();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_outlined),
                    title: const Text(
                      "Share",
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Share.share("${widget.note.text}");
                    },
                  ),
                  Visibility(
                    visible: isNotTrashPage(),
                    child: ListTile(
                      leading: const Icon(Icons.delete_outline_outlined),
                      title: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        showAlertDialogOkDelete(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialogOkDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm",
          ),
          content: const Text(
            "Delete ?",
          ),
          actions: [
            TextButton(
              child: const Text(
                "Yes",
              ),
              onPressed: () {
                _softDeleteNote();
                widget.reloadNotes!();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleSubtitle = const TextStyle(fontSize: 14);

    return Card.outlined(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: isNotTrashPage() ? openEditPage : null,
        onLongPress: openBottomMenu,
        title: Text(widget.note.text!, maxLines: 5, overflow: TextOverflow.ellipsis, style: styleSubtitle),
      ),
    );
  }
}
