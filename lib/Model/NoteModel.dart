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

  // تحويل الكائن إلى Map لإدخاله في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'headline': title, // تم التعديل ليطابق اسم العمود في Database
      'desc': description, // تم التعديل ليطابق اسم العمود في Database
      // ملاحظة: إذا أردت حفظ حالة isDone يجب إضافة عمود لها في الجدول أولاً
    };
  }

  // تحويل الـ Map القادمة من قاعدة البيانات إلى كائن Note
  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      id: data['id'],
      title: data['headline'] ?? '', // التأكد من استخدام نفس اسم العمود 'headline'
      description: data['desc'],     // التأكد من استخدام نفس اسم العمود 'desc'
      isDone: false, // قيمة افتراضية لأن الجدول الحالي لا يحتوي على عمود isDone
    );
  }
}