import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'core/encryption/encryption_service.dart';
import 'core/services/biometric_service.dart';
import 'core/storage/note_storage_service.dart';
import 'data/datasources/notes_local_datasource.dart';
import 'data/repositories/note_repository_impl.dart';
import 'domain/usecases/sync_notes.dart';
import 'feature/auth/data/repositories/BiometricServiceImpl.dart';
import 'feature/auth/data/repositories/biometric_repository_impl.dart';
import 'feature/auth/domain/repositories/biometric_repository.dart';
import 'feature/auth/domain/usecases/authenticate_biometrics.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/presentation/pages/auth_page.dart';
import 'feature/notes/presentation/bloc/note_bloc.dart';
import 'feature/notes/presentation/pages/create_edit_note_page.dart';
import 'feature/notes/presentation/pages/note_list_page.dart';
import 'feature/notes/presentation/pages/view_note_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  final biometricService = BiometricServiceImpl();
  final biometricRepository = BiometricRepositoryImpl(biometricService);
  final noteRepository = NoteRepositoryImpl(
    secureStorage: FlutterSecureStorage(),
    encrypter: encrypter,
    iv: iv,
    dataSource: NoteLocalDataSource(EncryptionService(key: key, iv: iv)), key: key,

  );
  final syncNotesUseCase = SyncNotesUseCase(noteRepository);


  runApp(MyApp(
    encryptionKey: key,
    iv: iv,
    encrypter: encrypter,
    biometricRepository: biometricRepository,
    syncNotesUseCase: syncNotesUseCase,
  ));
}


class MyApp extends StatelessWidget {
  final encrypt.Key encryptionKey;
  final IV iv;
  final Encrypter encrypter;
  final BiometricRepository biometricRepository;
  final SyncNotesUseCase syncNotesUseCase;

  MyApp({
    required this.encryptionKey,
    required this.iv,
    required this.encrypter,
    required this.syncNotesUseCase,
    required this.biometricRepository,
  });

  @override
  Widget build(BuildContext context) {
    final secureStorage = FlutterSecureStorage();
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NoteRepositoryImpl>(
              create: (context) => NoteRepositoryImpl(
                secureStorage: FlutterSecureStorage(),
                encrypter: encrypter,
                iv: iv,
                dataSource: NoteLocalDataSource(EncryptionService(key: encryptionKey, iv: iv)),
                key: encryptionKey,
              ),),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NoteBloc>(
              create: (context) => NoteBloc(
                RepositoryProvider.of<NoteRepositoryImpl>(context),
                syncNotesUseCase,
              ),
            ),
            BlocProvider(
              create: (_) => AuthBloc(biometricRepository),
            ),
          ],
          child:MaterialApp(
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/auth':
                  return MaterialPageRoute(builder: (_) => AuthenticationScreen(biometricRepository: biometricRepository,));
                case '/notesList':
                  return MaterialPageRoute(builder: (_) => NotesListScreen());
                case '/createNote':
                  return MaterialPageRoute(
                    builder: (_) => CreateEditNoteScreen(
                      isEdit: false,
                      encryptionService: EncryptionService(key: encryptionKey, iv: iv),
                      noteStorageService: NoteStorageService(),
                      secureStorage: secureStorage,
                    ),
                  );
                case '/editNote':
                  final args = settings.arguments as Map<String, dynamic>;
                  return MaterialPageRoute(
                    builder: (_) => CreateEditNoteScreen(
                      isEdit: true,
                      noteId: args['id'],
                      noteTitle: args['title'],
                      noteDescription: args['description'],
                      encryptionService: EncryptionService(key: encryptionKey, iv: iv),
                      noteStorageService: NoteStorageService(),
                      secureStorage: secureStorage,
                    ),
                  );
                case '/viewNote':
                  return MaterialPageRoute(
                    builder: (_) => ViewNoteScreen(
                      encryptionService: EncryptionService(key: encryptionKey, iv: iv),
                      noteStorageService: NoteStorageService(),
                    ),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => AuthenticationScreen(biometricRepository: biometricRepository,),
                  );
              }
            },
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            home: AuthenticationScreen(biometricRepository: biometricRepository,),
          )

        ));
  }
}
