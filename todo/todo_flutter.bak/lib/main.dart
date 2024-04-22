import 'package:flutter/material.dart';
import 'package:todo_client/todo_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// // Sets up a singleton client object that can be used to talk to the server from
// // anywhere in our app. The client is generated from your server code.
// // The client is set up to connect to a Serverpod running on a local server on
// // the default port. You will need to modify this to connect to staging or
// // production servers.
// var client = Client('http://$localhost:8080/')
//   ..connectivityMonitor = FlutterConnectivityMonitor();

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Serverpod Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Serverpod Example'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   // These fields hold the last result or error message that we've received from
//   // the server or null if no result exists yet.
//   String? _resultMessage;
//   String? _errorMessage;

//   final _textEditingController = TextEditingController();

//   // Calls the `hello` method of the `example` endpoint. Will set either the
//   // `_resultMessage` or `_errorMessage` field, depending on if the call
//   // is successful.
//   void _callHello() async {
//     try {
//       final result = await client.example.hello(_textEditingController.text);
//       setState(() {
//         _errorMessage = null;
//         _resultMessage = result;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = '$e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: TextField(
//                 controller: _textEditingController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter your name',
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: ElevatedButton(
//                 onPressed: _callHello,
//                 child: const Text('Send to Server'),
//               ),
//             ),
//             _ResultDisplay(
//               resultMessage: _resultMessage,
//               errorMessage: _errorMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // _ResultDisplays shows the result of the call. Either the returned result from
// // the `example.hello` endpoint method or an error message.
// class _ResultDisplay extends StatelessWidget {
//   final String? resultMessage;
//   final String? errorMessage;

//   const _ResultDisplay({
//     this.resultMessage,
//     this.errorMessage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     String text;
//     Color backgroundColor;
//     if (errorMessage != null) {
//       backgroundColor = Colors.red[300]!;
//       text = errorMessage!;
//     } else if (resultMessage != null) {
//       backgroundColor = Colors.green[300]!;
//       text = resultMessage!;
//     } else {
//       backgroundColor = Colors.grey[300]!;
//       text = 'No server response yet.';
//     }

//     return Container(
//       height: 50,
//       color: backgroundColor,
//       child: Center(
//         child: Text(text),
//       ),
//     );
//   }
// }

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Notes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note>? _notes;
  Exception? _connectionException;
  final client = Client('http://localhost:8080/')
    ..connectivityMonitor = FlutterConnectivityMonitor();

  void _connectionFailed(dynamic exception) {
    setState(() {
      _notes = null;
      _connectionException = exception;
    });
  }

  Future<void> _updateNote(Note note) async {
    try {
      await client.notes.updateNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await client.notes.getAllNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _createNote(Note note) async {
    try {
      await client.notes.createNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  Future<void> _deleteNote(Note note) async {
    try {
      await client.notes.deleteNote(note);
      await _loadNotes();
    } catch (e) {
      _connectionFailed(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _notes == null
          ? Center(
              child: _connectionException != null
                  ? Text(
                      'Connection Error: ${_connectionException!.toString()}')
                  : const CircularProgressIndicator())
          : ListView.builder(
              itemCount: _notes!.length,
              itemBuilder: (context, index) {
                final note = _notes![index];
                return Dismissible(
                  key: Key(note.id.toString()), // Unique key for each note
                  onDismissed: (direction) {
                    _deleteNote(note);
                  },
                  confirmDismiss: (direction) async {
                    return await _showDeleteConfirmation(context, note);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(note.text),
                    trailing: const Icon(Icons.drag_handle),
                    onTap: () async {
                      final updatedText = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNoteScreen(note: note),
                        ),
                      );
                      // print(updatedText);

                      if (updatedText != null) {
                        // Update the note
                        note.text = updatedText;
                        _updateNote(note);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog(
            context: context,
            onSaved: (text) {
              var note = Note(
                text: text,
              );
              _notes!.add(note);
              _createNote(note);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, Note note) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Note'),
            content: Text('Are you sure you want to delete "${note.text}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Close the dialog and return false
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Close the dialog and return true
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void showNoteDialog({
    required BuildContext context,
    required void Function(String) onSaved,
  }) {
    TextEditingController textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: 'Enter your note'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSaved(textEditingController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({super.key, required this.note});

  @override
  EditNoteScreenState createState() => EditNoteScreenState();
}

class EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.note.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textEditingController,
          decoration: const InputDecoration(hintText: 'Enter your note'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop(_textEditingController.text);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
