class Note {
  final int? id;
  String title;
  String? description;
  bool isDone;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    this.description,
    this.isDone = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // تحويل الكائن إلى Map لإدخاله في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_done': isDone ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // تحويل الـ Map القادمة من قاعدة البيانات إلى كائن Note
  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      id: data['id'],
      title: data['title'] ?? '',
      description: data['description'],
      isDone: data['is_done'] == 1,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  // إنشاء نسخة محدثة من الملاحظة
  Note copyWith({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
