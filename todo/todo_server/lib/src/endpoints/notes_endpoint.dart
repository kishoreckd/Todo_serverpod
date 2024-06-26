import '../generated/protocol.dart';
import 'package:serverpod/server.dart';

class NotesEndpoint extends Endpoint {
  Future<List<Note>> getAllNotes(Session session) async {
    // By ordering by the id column, we always get the notes in the same order
    // and not in the order they were updated.
    return await Note.db.find(
      session,
      orderBy: (t) => t.id,
    );
  }

  Future<void> createNote(Session session, Note note) async {
    await Note.db.insertRow(session, note);
  }

  Future<void> updateNote(Session session, Note note) async {
    await Note.db.updateRow(session, note);
  }

  Future<void> deleteNote(Session session, Note note) async {
    await Note.db.deleteRow(session, note);
  }
}
