import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final TextEditingController _controller = TextEditingController();
  List<String> todos = [];

  void addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        todos.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,   title: const Text('To Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      // Icon(Icons.add),
                      labelText: 'To-Do',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed:  (addTodo),
                    child: const Text('Add To-Do'),


                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: todos.isEmpty ? const Center(child: Text('No To-Do')) : ListView.builder(

                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onHorizontalDragEnd: (details) => setState(() {
                        removeTodo(index);
                    }),

                    child: Card (
                        child: ListTile(

                          trailing: IconButton(
                              onPressed: () {removeTodo(index);},
                              icon: const Icon(Icons.delete),
                              color: Colors.red,

                          ),

                      title: Text(todos[index]),
                    ) ),
                  )   ;



                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
