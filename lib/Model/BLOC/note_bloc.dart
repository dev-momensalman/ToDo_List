import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momensalman/Model/BLOC/note_event.dart';
import 'package:momensalman/Model/BLOC/note_state.dart';
import 'package:momensalman/Model/NoteModel.dart';
import 'package:momensalman/service/NoteDatabase.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteState(notes: [], isLoading: true)) {
    on<GetNotesEvent>((event, emit) async {
      emit(NoteState(notes: state.notes, isLoading: true));
      final notes = await NoteDatabase.getNotes();
      emit(NoteState(notes: notes, isLoading: false));
    });

    on<AddNoteEvent>((event, emit) async {
      final newNote = Note(title: event.title, description: event.description);
      await NoteDatabase.insertNote(newNote);
      add(GetNotesEvent()); // تحديث القائمة فوراً
    });

    on<DeleteNoteEvent>((event, emit) async {
      await NoteDatabase.deleteNote(event.id);
      add(GetNotesEvent()); // تحديث القائمة فوراً
    });
  }
}
