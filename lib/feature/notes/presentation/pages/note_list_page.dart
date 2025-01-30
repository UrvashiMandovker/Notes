import 'package:flutter/material.dart';
import '../../../../data/repositories/note_repository_impl.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import 'create_edit_note_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadNotes());
  }

  @override
  void didUpdateWidget(covariant NotesListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    context.read<NoteBloc>().add(LoadNotes());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900.withOpacity(0.8),
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sync, color: Colors.white),
            onPressed: () {
              context.read<NoteBloc>().add(SyncNotes());
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
        child:
        BlocConsumer<NoteBloc, NoteState>(
          listener: (context, state) {
            if (state is NoteSyncing) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is NoteSyncSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage),

                ),
              );
            } else if (state is NoteSyncError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.error}'),

                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NoteLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NoteError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is NoteSyncing) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NoteLoaded) {
              if (state.notes.isEmpty) {
                return Center(
                  child: Text(
                    'No notes yet! Tap the + button to create one.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.edit_note_outlined, color: Colors.white),
                      ),
                      title: Text(
                        note.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        note.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.pushNamed(
                              context,
                              '/editNote',
                              arguments: {
                                'id': note.id,
                                'title': note.title,
                                'description': note.description,
                                'createdAt': note.createdAt,
                              },
                            );
                          } else if (value == 'delete') {
                            context.read<NoteBloc>().add(DeleteNote(note.id));
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: Text('Unexpected state')); // Fallback
          },
        ),

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createNote');
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.blueAccent, size: 30),
      ),
    );
  }
}

