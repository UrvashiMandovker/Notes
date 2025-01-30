import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/encryption/encryption_service.dart';
import '../model/note_model.dart';

class NoteLocalDataSource {
  final EncryptionService encryptionService;

  NoteLocalDataSource(this.encryptionService);

  Future<String> _getFilePath(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$id.json';
  }

  Future<void> saveNote(NoteModel note) async {
    final filePath = await _getFilePath(note.id);
    final file = File(filePath);

    final encryptedData = encryptionService.encryptText(jsonEncode(note.toMap()));
    await file.writeAsString(encryptedData);
  }

  Future<List<NoteModel>> getAllNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    List<NoteModel> notes = [];

    for (var file in files) {
      if (file is File && file.path.endsWith('.json')) {
        final encryptedData = await file.readAsString();
        final decryptedData = encryptionService.decryptText(encryptedData);
        notes.add(NoteModel.fromMap(jsonDecode(decryptedData)));
      }
    }
    return notes;
  }

  Future<NoteModel> getNoteById(String id) async {
    final filePath = await _getFilePath(id);
    final file = File(filePath);

    if (await file.exists()) {
      final encryptedData = await file.readAsString();
      final decryptedData = encryptionService.decryptText(encryptedData);
      return NoteModel.fromMap(jsonDecode(decryptedData));
    } else {
      throw Exception("Note not found");
    }
  }

  Future<void> deleteNoteById(String id) async {
    final filePath = await _getFilePath(id);
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }
  Future<bool> syncNotes() async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
