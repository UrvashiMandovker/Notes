import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/note.dart';
import '../../../../domain/repositories/notes_repository.dart';
import '../../../../domain/usecases/sync_notes.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;
  final SyncNotesUseCase syncNotesUseCase;

  NoteBloc(this.noteRepository,this.syncNotesUseCase) : super(NoteLoading()) {
    on<LoadNotes>((event, emit) async {
      emit(NoteLoading());
      try {
        final notes = await noteRepository.getAllNotes();
        emit(NoteLoaded(notes));
      } catch (e) {
        emit(NoteError('Failed to load notes: $e'));
      }
    });
    on<AddNote>((event, emit) async {
      if (state is NoteLoaded) {
        try {
          await noteRepository.saveNote(event.note);
          final notes = List<Note>.from((state as NoteLoaded).notes)
            ..add(event.note);
          emit(NoteLoaded(notes));
        } catch (e) {
          emit(NoteError("Failed to add note: $e"));
        }
      }
    });

    on<EditNote>((event, emit) async {
      if (state is NoteLoaded) {
        final notes = (state as NoteLoaded).notes.map((note) {
          return note.id == event.note.id ? event.note : note;
        }).toList();

        emit(NoteLoaded(notes));

        try {
          for (final note in notes) {
            await noteRepository.saveNote(note);
          }
        } catch (e) {
          emit(NoteError('Failed to update note.'));
        }
      }
    });

    on<DeleteNote>((event, emit) async {
      if (state is NoteLoaded) {
        try {
          final notes = (state as NoteLoaded)
              .notes
              .where((note) => note.id != event.noteId)
              .toList();

          await noteRepository.deleteNoteById(event.noteId);

          emit(NoteLoaded(notes));
        } catch (e) {
          emit(NoteError("Failed to delete note: $e"));
        }
      }
    });

    on<SyncNotes>((event, emit) async {
      emit(NoteSyncing('Syncing notes...'));
      try {
        await syncNotesUseCase.syncNotes();
        emit(NoteSyncSuccess('Sync completed successfully!'));
        final notes = await noteRepository.getAllNotes();
        emit(NoteLoaded(notes));

      } catch (e) {
        emit(NoteSyncError(e.toString()));
      }
    });
  }
}
