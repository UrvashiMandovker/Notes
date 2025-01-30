import 'dart:convert';
import 'dart:isolate';
import 'package:encrypt/encrypt.dart' as encryption ;
import 'dart:async';


class EncryptionIsolate {
  static Future<String> encrypt(String text, encryption.Key key) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_encryptTask, [receivePort.sendPort, text, key]);
    final result = await receivePort.first;
    if (result is String) {
      return result;
    } else {
      throw Exception("Encryption failed");
    }
  }

  static Future<String> decrypt(String encryptedText, encryption.Key key) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_decryptTask, [receivePort.sendPort, encryptedText, key]);
    final result = await receivePort.first;
    if (result is String) {
      return result;
    } else {
      throw Exception("Decryption failed");
    }
  }

  static void _encryptTask(List<dynamic> args) {
    final sendPort = args[0] as SendPort;
    final text = args[1] as String;
    final key = args[2] as encryption.Key;

    try {
      final encrypted = _performEncryption(text, key);
      sendPort.send(encrypted);
    } catch (e) {
      sendPort.send("Encryption failed: $e");
    }
  }

  static void _decryptTask(List<dynamic> args) {
    final sendPort = args[0] as SendPort;
    final encryptedText = args[1] as String;
    final key = args[2] as encryption.Key;

    try {
      final decrypted = _performDecryption(encryptedText, key);
      sendPort.send(decrypted);
    } catch (e) {
      sendPort.send("Decryption failed: $e");
    }
  }

  static String _performEncryption(String text, encryption.Key key) {
    final iv = encryption.IV.fromLength(16);
    final encrypter = encryption.Encrypter(encryption.AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static String _performDecryption(String encryptedText, encryption.Key key) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw FormatException("Invalid encrypted text format");
    }

    final iv = encryption.IV.fromBase64(parts[0]);
    final cipherText = parts[1];
    final encrypter = encryption.Encrypter(encryption.AES(key));

    return encrypter.decrypt64(cipherText, iv: iv);
  }
}
