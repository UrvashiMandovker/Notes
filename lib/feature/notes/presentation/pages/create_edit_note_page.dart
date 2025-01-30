import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maatra2/domain/entities/note.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/encryption/encryption_service.dart';
import '../../../../core/storage/note_storage_service.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';

class CreateEditNoteScreen extends StatelessWidget {
  final bool isEdit;
  final String? noteTitle;
  final String? noteDescription;
  final EncryptionService encryptionService;
  final NoteStorageService noteStorageService;
  final FlutterSecureStorage secureStorage;
  final String? noteId;

  CreateEditNoteScreen({
    Key? key,
    required this.isEdit,
    this.noteTitle,
    this.noteDescription,
    required this.encryptionService,
    required this.noteStorageService,
    required this.secureStorage,
    this.noteId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: noteTitle ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: noteDescription ?? '');

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          isEdit ? 'Edit Note' : 'Create Note',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900.withOpacity(0.8),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final note = Note(
                id: isEdit ? noteId ?? "" : Uuid().v4(),
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                createdAt: DateTime.now(),
              );

              if (isEdit) {
                context.read<NoteBloc>().add(EditNote(note));
              } else {
                context.read<NoteBloc>().noteRepository.saveNote(note);
                context.read<NoteBloc>().add(AddNote(note));
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade900.withOpacity(0.8),
              Colors.blueAccent.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title TextField
            TextField(
              controller: titleController,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Description TextField
            Expanded(
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final note = Note(
            id: isEdit ? noteId! : Uuid().v4(),
            title: titleController.text.trim(),
            description: descriptionController.text.trim(),
            createdAt: DateTime.now(),
          );

          if (isEdit) {
            context.read<NoteBloc>().add(EditNote(note));
          } else {
            context.read<NoteBloc>().noteRepository.saveNote(note);
            context.read<NoteBloc>().add(AddNote(note));
          }

          Navigator.pop(context);
        },
        backgroundColor: Colors.white,
        label: Text(
          isEdit ? 'Save Changes' : 'Create Note',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
