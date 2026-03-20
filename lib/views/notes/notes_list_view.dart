import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import '../../controllers/note_controller.dart';
import '../../controllers/firebase_auth_controller.dart';
import '../../services/notification_service.dart';
import 'notification_test_view.dart';
import 'dart:developer';

class NotesListView extends StatefulWidget {
  final NoteController controller;
  final FirebaseAuthController? authController;

  const NotesListView({
    super.key,
    required this.controller,
    this.authController,
  });

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  final Color primaryColor = const Color(0xFF6C5CE7);
  final Color accentColor = const Color(0xFF00CEC9);
  final Color bgColor = const Color(0xFFF8F9FD);
  List<Note> _cachedNotes = []; // Cache notes

  @override
  void initState() {
    super.initState();
    log('NotesListView initState started');
    
    // Load notes asynchronously with error handling
    _loadNotesAsync();
  }

  Future<void> _loadNotesAsync() async {
    try {
      log('Starting to load notes...');
      final notes = await widget.controller.loadNotes();
      log('Notes loaded successfully: ${notes.length} notes');
      
      if (mounted) {
        setState(() {
          _cachedNotes = notes;
          log('UI updated with ${notes.length} notes');
        });
      }
    } catch (e) {
      log('Error loading notes: $e');
      if (mounted) {
        setState(() {
          _cachedNotes = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Building NotesListView with ${_cachedNotes.length} cached notes');
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "CloudNote - ${widget.authController?.userDisplayName ?? 'User'}",
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xFF6C5CE7),
        actions: [
          IconButton(
            onPressed: () async {
              if (widget.authController != null) {
                await widget.authController!.signOut();
              }
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Logout",
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationTestView(),
                ),
              );
            },
            icon: const Icon(Icons.notifications, color: Color(0xFF6C5CE7)),
            tooltip: "Test Notifications",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddNoteDialog(),
      ),
      body: ValueListenableBuilder<List<Note>>(
        valueListenable: widget.controller.notes,
        builder: (context, notes, _) {
          if (widget.controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Use cached notes for better performance
          final displayNotes = _cachedNotes.isNotEmpty ? _cachedNotes : notes;
          
          if (displayNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 60,
                    color: primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No notes yet!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("Tap + to add a new note"),
                ],
              ),
            );
          }
          
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: displayNotes.length,
            itemBuilder: (context, index) {
              logger.log('Building note card for index: $index');
              return _buildNoteCard(displayNotes[index], index);
            },
          );
        },
      ),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    log('Building note card: ${note.title}');
    return Dismissible(
      key: ValueKey(note.id ?? (note.title + index.toString())),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        log('Dismissing note: ${note.title}');
        if (note.id != null) {
          widget.controller.deleteNote(note.id!);
        }
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditNoteDialog(note),
                    ),
                  ],
                ),
              ],
            ),
            if (note.description != null && note.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                note.description!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  decoration: note.isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Created: ${_formatDate(note.createdAt)}',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    _showNoteDialog();
  }

  void _showEditNoteDialog(Note note) {
    _showNoteDialog(note: note);
  }

  void _showNoteDialog({Note? note}) {
    final isEditing = note != null;
    final titleController = TextEditingController(text: note?.title ?? '');
    final descriptionController = TextEditingController(
      text: note?.description ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit Note" : "Add New Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                if (isEditing) {
                  widget.controller.updateNote(
                    note!.copyWith(
                      title: titleController.text,
                      description: descriptionController.text.isEmpty
                          ? null
                          : descriptionController.text,
                    ),
                  );
                } else {
                  widget.controller.addNote(
                    title: titleController.text,
                    description: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  );
                }
                Navigator.pop(context);
              }
            },
            child: Text(isEditing ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
