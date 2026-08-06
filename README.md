# CloudNote

CloudNote is a Flutter notes app with a simple login gate, local note storage, and Bloc-based state management. It focuses on a clean note-taking flow: open the app, pass the saved login check, add notes, review them in a modern list, and remove notes with a swipe gesture.

## Overview

The project combines several important Flutter concepts in one app: persistent login state with `shared_preferences`, local SQLite storage with `sqflite`, Bloc events and states for note operations, and a polished notes screen with empty states, dialogs, dismissible cards, and logout handling.

## Features

- Login gate that checks saved session state before opening the app
- Persistent session flag using `shared_preferences`
- Add notes with headline and optional description
- Display notes from local SQLite storage
- Delete notes using swipe-to-delete
- Bloc-based note loading, adding, and deleting
- Clean empty-state screen when there are no notes
- Logout action that clears the saved session
- Material 3 app theme

## Tech Stack

- Flutter
- Dart
- Flutter Bloc
- SQLite through `sqflite`
- `shared_preferences`
- `path` for database path handling

## Project Structure

```text
lib/
├── main.dart                         # App entry point and Bloc provider
├── Screens/
│   ├── AuthGate.dart                 # Session check and routing
│   ├── Todo.dart                     # Main CloudNote screen
│   ├── NoteScreen.dart               # Alternate notes screen
│   ├── login.dart                    # Login screen
│   ├── users_screen.dart             # Users display screen
│   └── insta.dart                    # Additional UI screen
├── Model/
│   ├── NoteModel.dart                # Note model and database mapping
│   ├── TodoModel.dart                # Todo model
│   ├── Users.dart                    # User model
│   └── BLOC/
│       ├── note_bloc.dart            # Note business logic
│       ├── note_event.dart           # Note events
│       ├── note_state.dart           # Note state
│       ├── TodoBloC.dart             # Todo Bloc
│       ├── TodoEvent.dart            # Todo events
│       └── TodoState.dart            # Todo state
└── service/
    ├── NoteDatabase.dart             # SQLite note database helper
    └── CallApi.dart                  # API helper
```

## Main Flow

1. `main.dart` creates a `NoteBloc` and starts the app.
2. `AuthGate` checks `shared_preferences` for the `isLoggedIn` flag.
3. Logged-in users are sent to `TodoScreen`; otherwise they see `LoginPage`.
4. `TodoScreen` requests notes through `GetNotesEvent`.
5. Adding a note sends `AddNoteEvent` to the Bloc.
6. Deleting a note sends `DeleteNoteEvent` and removes it from SQLite.
7. `NoteDatabase` handles table creation, insert, read, and delete operations.

## Getting Started

### Requirements

- Flutter SDK 3.9.2 or newer
- Dart SDK included with Flutter
- Android Studio, VS Code, or another Flutter-compatible IDE

### Run Locally

```bash
git clone https://github.com/dev-momensalman/ToDo_List.git
cd ToDo_List
flutter pub get
flutter run
```

## Notes for Reviewers

- The README also fixes the previous merge-conflict text that was visible in the file.
- The main screen is `lib/Screens/Todo.dart`.
- The app state flow is easiest to review through `main.dart`, `AuthGate.dart`, and the files inside `lib/Model/BLOC`.
- Local persistence is handled in `lib/service/NoteDatabase.dart`.
- The app currently stores notes locally on the device, not in a remote backend.

## Future Improvements

- Add note editing
- Add validation and clearer login feedback
- Separate authentication, notes, and additional screens into feature folders
- Add tests for Bloc events and database operations
- Add search or filtering for notes
