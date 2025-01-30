import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveKey(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getKey(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }
}
