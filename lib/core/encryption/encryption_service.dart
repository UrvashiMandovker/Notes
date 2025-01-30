import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:maatra2/core/encryption/secure_storage_service.dart';

class EncryptionService {
  final encrypt.Key key;
  final encrypt.IV iv;

  EncryptionService({required this.key, required this.iv});

  String encryptText(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptText(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }

}
