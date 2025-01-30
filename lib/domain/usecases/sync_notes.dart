
import '../../core/encryption/encryption_isolate.dart';
import '../repositories/notes_repository.dart';

class SyncNotesUseCase {
  final NoteRepository repository;

  SyncNotesUseCase(this.repository);
  Future<void> syncNotes() async {
    try {
      final notes = await repository.getAllNotes();

      for (var note in notes) {
        await repository.syncNoteToRemoteServer(
          id: note.id,
          title: note.title,
          description: note.description,
        );
      }

    } catch (e) {
      rethrow;
    }
  }
}

