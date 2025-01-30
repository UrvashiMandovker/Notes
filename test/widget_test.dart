// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:local_auth/local_auth.dart';
import 'package:maatra2/core/encryption/encryption_service.dart';
import 'package:maatra2/core/services/biometric_service.dart';
import 'package:maatra2/data/datasources/notes_local_datasource.dart';
import 'package:maatra2/data/repositories/note_repository_impl.dart';
import 'package:maatra2/domain/usecases/sync_notes.dart';
import 'package:maatra2/feature/auth/data/repositories/BiometricServiceImpl.dart';
import 'package:maatra2/feature/auth/data/repositories/biometric_repository_impl.dart';
import 'package:maatra2/feature/auth/domain/usecases/authenticate_biometrics.dart';
import 'package:maatra2/main.dart';

void main() {
  final encryptionKey = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));
  final biometricService = BiometricServiceImpl();
  final biometricRepository = BiometricRepositoryImpl(biometricService);
  final noteRepository = NoteRepositoryImpl(
    secureStorage: FlutterSecureStorage(),
    encrypter: encrypter,
    iv: iv,
    dataSource: NoteLocalDataSource(EncryptionService(key: encryptionKey, iv: iv)), key: encryptionKey,

  );
  final syncNotesUseCase = SyncNotesUseCase(noteRepository);

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(encryptionKey: encryptionKey, iv: iv, encrypter: encrypter,  syncNotesUseCase: syncNotesUseCase, biometricRepository: biometricRepository,));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
