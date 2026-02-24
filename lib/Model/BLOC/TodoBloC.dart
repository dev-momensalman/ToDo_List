import 'package:flutter_bloc/flutter_bloc.dart';
import 'TodoEvent.dart';
import 'TodoState.dart';
import '../../Model/TodoModel.dart';

class TodoBloC extends Bloc<TodoEvent, TodoState> {
  TodoBloC() : super(TodoState(todos: [])) {
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodo>(_onToggleTodo);
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) {
    // ننشئ قائمة جديدة تماماً لضمان تحديث الـ UI
    final newTodos = List<Todo>.from(state.todos)..add(Todo(title: event.task));
    emit(TodoState(todos: newTodos));
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    final newTodos = List<Todo>.from(state.todos)..removeAt(event.index);
    emit(TodoState(todos: newTodos));
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final List<Todo> updatedTodos = List<Todo>.from(state.todos);
    final current = updatedTodos[event.index];

    // تغيير الحالة عن طريق إنشاء كائن جديد
    updatedTodos[event.index] = Todo(
      title: current.title,
      isDone: !current.isDone,
    );

    emit(TodoState(todos: updatedTodos));
  }
}