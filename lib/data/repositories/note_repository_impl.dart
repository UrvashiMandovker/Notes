import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';
import '../../core/encryption/encryption_isolate.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';


class NoteRepositoryImpl implements NoteRepository {
  final FlutterSecureStorage secureStorage;
  final encrypt.Encrypter encrypter;
  final encrypt.IV iv;
  final encrypt.Key key;
  final NoteLocalDataSource dataSource;
  final Lock _lock = Lock();

  NoteRepositoryImpl({
    required this.secureStorage,
    required this.encrypter,
    required this.iv,
    required this.dataSource,
    required this.key,
  });

  @override
  Future<void> syncNoteToRemoteServer({
    required String id,
    required String title,
    required String description,
  }) async {
    await _lock.synchronized(() async {
      await Future.delayed(Duration(seconds: 1));
    });
  }

  @override
  Future<void> saveNote(Note note) async {
    await _lock.synchronized(() async {
      try {
        final encryptedNote = await EncryptionIsolate.encrypt(
          jsonEncode(note.toJson()),
          key,
        );
        await secureStorage.write(key: note.id, value: encryptedNote);
      } catch (e) {
        rethrow;
      }
    });
  }


  @override
  Future<List<Note>> getAllNotes() async {
    try {
      final encryptedNotes = await secureStorage.readAll();
      if (encryptedNotes.isEmpty) {
        return [];
      }
      List<Note> notesList = [];
      for (var entry in encryptedNotes.entries) {
        try {
          final decrypted = await EncryptionIsolate.decrypt(entry.value, key);
          final noteJson = jsonDecode(decrypted);
          notesList.add(Note.fromJson(noteJson));
        } catch (e) {
        }
      }
      return notesList..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      return [];
    }
  }


  @override
  Future<void> updateNotes(List<Note> notes) async {
    await _lock.synchronized(() async {
      try {
        await secureStorage.deleteAll();

        for (var note in notes) {
          await saveNote(note);
        }
      } catch (e) {
        rethrow;
      }
    });
  }

  @override
  Future<void> deleteNoteById(String noteId) async {
    await _lock.synchronized(() async {
      try {
        await secureStorage.delete(key: noteId);
      } catch (e) {
        rethrow;
      }
    });
  }
}



