import '../entities/note.dart';

abstract class NoteRepository {
  Future<void> syncNoteToRemoteServer({
    required String id,
    required String title,
    required String description,
  });
  Future<void> saveNote(Note note);
  Future<List<Note>> getAllNotes();
  Future<void> deleteNoteById(String id);
  Future<void> updateNotes(List<Note> note);
}
