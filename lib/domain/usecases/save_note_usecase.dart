
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class SaveNote {
  final NoteRepository repository;

  SaveNote(this.repository);

  Future<void> call(Note note) async {
    await repository.saveNote(note);
  }
}

class GetAllNotes {
  final NoteRepository repository;

  GetAllNotes(this.repository);

  Future<List<Note>> call() async {
    return await repository.getAllNotes();
  }
}

class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  Future<void> call(String id) async {
    await repository.deleteNoteById(id);
  }
}
