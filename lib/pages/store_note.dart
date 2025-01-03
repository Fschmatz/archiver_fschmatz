import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../entity/note.dart';
import '../service/note_service.dart';
import '../utils/utils.dart';

class StoreNote extends StatefulWidget {
  final Function() refreshHome;
  final Note? note;
  final bool isInsert;
  final bool isUpdate;

  const StoreNote({super.key, required this.refreshHome, this.note, required this.isInsert, required this.isUpdate});

  @override
  State<StoreNote> createState() => _StoreNoteState();
}

class _StoreNoteState extends State<StoreNote> {
  final NoteService _noteService = NoteService();
  final TextEditingController _controllerNoteText = TextEditingController();
  bool readOnly = true;
  bool _isInsert = false;
  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();

    _isInsert = widget.isInsert;
    _isUpdate = widget.isUpdate;

    if (_isUpdate) {
      _controllerNoteText.text = widget.note!.text!;
    }
  }

  Future<void> _saveNote() async {
    Note noteToInsert = Note.createNewForInsert(text: _controllerNoteText.text.trim());

    _noteService.insert(noteToInsert);
  }

  Future<void> _updateNote() async {
    Note noteToUpdate = widget.note!;
    noteToUpdate.text = _controllerNoteText.text.trim();

    _noteService.update(noteToUpdate);
  }

  _launchLink(String link) {
    Utils().launchBrowser(link);
  }

  String _formatNoteToCopy() {
    return _controllerNoteText.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            (_isUpdate && readOnly)
                ? IconButton(
                    icon: const Icon(Icons.copy_outlined),
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _formatNoteToCopy()));
                    },
                  )
                : const SizedBox.shrink(),
            (_isUpdate && !readOnly)
                ? IconButton(
                    icon: const Icon(Icons.save_outlined),
                    tooltip: 'Save',
                    onPressed: () {
                      if (!readOnly) {
                        if (_controllerNoteText.text.isNotEmpty) {
                          _updateNote().then((v) => {widget.refreshHome(), Navigator.of(context).pop()});
                        } else {
                          Fluttertoast.showToast(msg: "Note is empty!");
                        }
                      }
                    },
                  )
                : const SizedBox.shrink(),
            (_isInsert)
                ? IconButton(
                    icon: const Icon(Icons.save_outlined),
                    tooltip: 'Save',
                    onPressed: () {
                      if (_controllerNoteText.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Note is empty!");
                      } else {
                        _saveNote().then((v) => {
                              widget.refreshHome(),
                              Navigator.of(context).pop(),
                            });
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DetectableTextField(
                readOnly: _isUpdate ? readOnly: false,
                autofocus: _isInsert,
                minLines: 1,
                maxLines: null,
                maxLength: 2000,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textCapitalization: TextCapitalization.sentences,
                controller: _controllerNoteText,
                detectionRegExp: RegExp(
                  // "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
                  r'\b(?:https?://|www\.)\S+\b',
                  multiLine: true,
                ),
                onDetectionTyped: (text) {
                  readOnly ? _launchLink(text) : null;
                },
                basicStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoratedStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    counterText: "",
                    fillColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hintText: "...",
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    )),
              )),
          const SizedBox(
            height: 50,
          ),
        ]),
        floatingActionButton: (_isUpdate && readOnly)
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    readOnly = !readOnly;
                  });
                },
                child: const Icon(
                  Icons.edit_outlined,
                ),
              )
            : null);
  }
}
