import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/note_service.dart';

class BackupUtils {
  NoteService noteService = NoteService();

 /* PER APP SPECIFIC FUNCTIONS */

  Future<List<Map<String, dynamic>>> _loadAllNotes() async {
    return noteService.findAllNotes();
  }

  Future<void> _deleteAllNotes() async {
    await noteService.deleteAllNotes();
  }

  Future<void> _insertNotes(List<dynamic> jsonData) async {
    await noteService.insertNotesFromRestoreBackup(jsonData);
  }

 /* END PER APP SPECIFIC FUNCTIONS */

  Future<void> _loadStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  // Always using Android Download folder
  Future<String> _loadDirectory() async {
    bool dirDownloadExists = true;
    String directory = "/storage/emulated/0/Download/";

    dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      directory = "/storage/emulated/0/Download/";
    } else {
      directory = "/storage/emulated/0/Downloads/";
    }

    return directory;
  }

  Future<void> backupData(String fileName) async {
    await _loadStoragePermission();

    List<Map<String, dynamic>> list = await _loadAllNotes();

    if (list.isNotEmpty) {
      await _saveListAsJson(list, fileName);

      Fluttertoast.showToast(
        msg: "Backup completed!",
      );
    } else {
      Fluttertoast.showToast(
        msg: "No data found!",
      );
    }
  }

  Future<void> _saveListAsJson(List<Map<String, dynamic>> data, String fileName) async {
    try {
      String directory = await _loadDirectory();

      final file = File('$directory/$fileName.json');

      await file.writeAsString(json.encode(data));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error!",
      );
    }
  }

  Future<void> restoreBackupData(String fileName) async {
    await _loadStoragePermission();

    try {
      String directory = await _loadDirectory();

      final file = File('$directory/$fileName.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      await _deleteAllNotes();
      await _insertNotes(jsonData);

      Fluttertoast.showToast(
        msg: "Success!",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error!",
      );
    }
  }
}
