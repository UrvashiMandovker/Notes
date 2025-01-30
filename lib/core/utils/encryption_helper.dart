import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  final Key key;
  final IV iv;

  EncryptionHelper(String secureKey)
      : key = Key.fromUtf8(secureKey.padRight(32).substring(0, 32)),
        iv = IV.fromLength(16);

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  String decrypt(String cipherText) {
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.fromBase64(cipherText), iv: iv);
  }
}
