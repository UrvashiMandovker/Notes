import 'package:equatable/equatable.dart';

import '../../../../domain/entities/note.dart';

abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}

class SyncNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final Note note;

  AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

class EditNote extends NoteEvent {
  final Note note;

  EditNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}