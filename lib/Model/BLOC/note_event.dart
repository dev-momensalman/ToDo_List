abstract class NoteEvent {}


class LoadNotesEvent extends NoteEvent {}

class GetNotesEvent extends NoteEvent {}



class AddNoteEvent extends NoteEvent {
  final String title;
  final String description;

  AddNoteEvent({required this.title, required this.description});
}


class DeleteNoteEvent extends NoteEvent {
  final int id;

  DeleteNoteEvent({required this.id});
}
