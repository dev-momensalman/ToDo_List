import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';
import '../services/database_service.dart';

class NoteController {
  final ValueNotifier<List<Note>> notes = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> loadNotes() async {
    try {
      isLoading.value = true;
      final loadedNotes = await DatabaseService.instance.getAllNotes();
      notes.value = loadedNotes;
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote({
    required String title,
    String? description,
  }) async {
    try {
      final newNote = Note(
        title: title,
        description: description,
      );

      await DatabaseService.instance.insertNote(newNote);
      await loadNotes(); // إعادة تحميل القائمة
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      await DatabaseService.instance.updateNote(updatedNote);
      await loadNotes(); // إعادة تحميل القائمة
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await DatabaseService.instance.deleteNote(id);
      await loadNotes(); // إعادة تحميل القائمة
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  Future<void> toggleNoteStatus(Note note) async {
    try {
      final updatedNote = note.copyWith(
        isDone: !note.isDone,
        updatedAt: DateTime.now(),
      );
      await DatabaseService.instance.updateNote(updatedNote);
      await loadNotes(); // إعادة تحميل القائمة
    } catch (e) {
      debugPrint('Error toggling note status: $e');
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    try {
      final allNotes = await DatabaseService.instance.getAllNotes();
      return allNotes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
               (note.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    } catch (e) {
      debugPrint('Error searching notes: $e');
      return [];
    }
  }

  Future<List<Note>> getNotesByStatus(bool isDone) async {
    try {
      final allNotes = await DatabaseService.instance.getAllNotes();
      return allNotes.where((note) => note.isDone == isDone).toList();
    } catch (e) {
      debugPrint('Error filtering notes by status: $e');
      return [];
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void dispose() {
    notes.dispose();
    isLoading.dispose();
  }
}
