abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final String task;
  AddTodo({required this.task});
}

class DeleteTodo extends TodoEvent {
  final int index;
  DeleteTodo({required this.index});
}

class ToggleTodo extends TodoEvent { // تأكد من أن الاسم ToggleTodo وليس ToggleTodoEvent
  final int index;
  ToggleTodo({required this.index});
}