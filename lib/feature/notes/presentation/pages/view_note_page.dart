import 'package:flutter/material.dart';

import '../../../../core/encryption/encryption_service.dart';
import '../../../../core/storage/note_storage_service.dart';

class ViewNoteScreen extends StatelessWidget {
  final EncryptionService encryptionService;
  final NoteStorageService noteStorageService;

  ViewNoteScreen({
    Key? key,
    required this.encryptionService,
    required this.noteStorageService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final args = arguments is Map<String, String?> ? arguments : {};

    final String noteId = args['noteId'] ?? '';
    final String title = args['title'] ?? 'No Title';
    final String description = args['description'] ?? 'No Description';
    final String date = args['createdAt'] ?? 'No Date';


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'View Note',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900.withOpacity(0.8),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editNote', arguments: {
                'noteId': noteId,
                'title': title,
                'description': description,
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Note'),
                  content: Text('Are you sure you want to delete this note?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Delete the note and go back
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child:
                          Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
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
            Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Created on: ${date}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Divider(
              color: Colors.white70,
              thickness: 1,
              height: 20,
            ),
            Expanded(
                child: SingleChildScrollView(
                        child: Text(
                          description,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      )
            )
          ],
        ),
      ),
    );
  }
}
