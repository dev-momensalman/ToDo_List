import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:momensalman/Model/NoteModel.dart';

class NoteDatabase {
  // فتح قاعدة البيانات وإنشاء الجدول
  static Future<Database> openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notes('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'headline TEXT NOT NULL, ' // هذا هو الاسم المستخدم في الـ Model الآن
          'desc TEXT' // هذا هو الاسم المستخدم في الـ Model الآن
          ')',
        );
      },
    );
  }

  // إدخال ملاحظة جديدة
  static Future<void> insertNote(Note note) async {
    final db = await openDB();
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // جلب كل الملاحظات وتحويلها لقائمة من كائنات Note
  static Future<List<Note>> getNotes() async {
    final db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (index) {
      return Note.fromMap(maps[index]);
    });
  }

  // حذف ملاحظة
  static Future<void> deleteNote(int id) async {
    final db = await openDB();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
