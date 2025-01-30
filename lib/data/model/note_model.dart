
import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required String id,
    required String title,
    required String description,
    required DateTime createdAt,
  }) : super(id: id, title: title, description: description,createdAt: createdAt );

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
