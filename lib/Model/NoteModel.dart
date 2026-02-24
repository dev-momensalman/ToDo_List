class Note {
  final int? id;
  String title;
  String? description;
  bool isDone;

  Note({
    this.id,
    required this.title,
    this.description,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      isDone: data['isDone'] ?? false,
    );
  }
}