import 'package:equatable/equatable.dart';

import '../../../../domain/entities/note.dart';

abstract class NoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;

  NoteLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NoteError extends NoteState {
  final String error;

  NoteError(this.error);

  @override
  List<Object?> get props => [error];
}
class NoteSyncing extends NoteState {
  final String message;
  NoteSyncing(this.message);
}

class NoteSyncSuccess extends NoteState {
  final String successMessage;
  NoteSyncSuccess(this.successMessage);
}

class NoteSyncError extends NoteState {
  final String error;
  NoteSyncError(this.error);
}
