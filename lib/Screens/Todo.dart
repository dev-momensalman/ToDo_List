import 'package:flutter/material.dart';
import '../Model/Notemodel.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Note> notes = [];

  final Color primaryColor = const Color(0xFF6C5CE7);
  final Color accentColor = const Color(0xFF00CEC9);
  final Color bgColor = const Color(0xFFF8F9FD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => _showAddNoteDialog(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: notes.isEmpty
            ? Center(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text("Tap + to add a new note"),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) =>
                    _buildNoteCard(notes[index], index),
              ),
      ),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    return Dismissible(
      key: ValueKey(note.title + index.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => setState(() => notes.removeAt(index)),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        width: double.infinity, // الكارد ياخد العرض بالكامل
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (note.description != null && note.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                note.description!,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    TextEditingController headlineController = TextEditingController();
    TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: headlineController,
              decoration: const InputDecoration(labelText: "Headline"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
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
              if (headlineController.text.isNotEmpty) {
                setState(() {
                  notes.add(
                    Note(
                      title: headlineController.text,
                      description: descController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}