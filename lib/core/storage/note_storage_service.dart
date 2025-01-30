import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NoteStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Write an encrypted note to local storage
  Future<void> writeNote(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read an encrypted note from local storage
  Future<String?> readNote(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a note from local storage
  Future<void> deleteNote(String key) async {
    await _storage.delete(key: key);
  }

  /// Get all saved keys
  Future<List<String>> getAllKeys() async {
    final allKeys = await _storage.readAll();
    return allKeys.keys.toList();
  }
}
