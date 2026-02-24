import 'package:momensalman/Model/NoteModel.dart';

class NoteState {
  final List<Note> notes;
final bool isLoading;


  NoteState({required this.notes, required this.isLoading});
}