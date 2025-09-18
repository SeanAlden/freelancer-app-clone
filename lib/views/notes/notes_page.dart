import 'package:clone_freelancer_mobile/controllers/notes_database.dart';
import 'package:clone_freelancer_mobile/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes = [];
  bool isLoading = false;
  // String? userEmail;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'notes'.tr, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(child: Text('no_notes'.tr))
              : buildNotes(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditNotePage(),
          ));
          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Dismissible(
            key: ValueKey(note.id),
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await NotesDatabase.instance.delete(note.id!);
              refreshNotes();
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child:
                      Text(note.title[0]), // Avatar berisi huruf pertama judul
                ),
                title: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddEditNotePage(note: note),
                  ));
                  refreshNotes();
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => showDeleteConfirmationDialog(note),
                ),
              ),
            ),
          );
        },
      );

  // Function to show delete confirmation dialog
  void showDeleteConfirmationDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('delete_note'.tr),
          content: Text('delete_note_confirm'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text('no'.tr),
            ),
            TextButton(
              onPressed: () async {
                await NotesDatabase.instance.delete(note.id!);
                Navigator.of(context).pop(); // Close the dialog
                refreshNotes(); // Refresh notes list after deletion
              },
              child: Text('yes'.tr, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  // final String userEmail;

  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String content;

  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.note == null ? 'add_note'.tr : 'edit_note'.tr,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'note_title'.tr),
                onChanged: (value) => setState(() => title = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_a_title'.tr;
                  }
                  return null;
                },
                minLines: 1, // Minimal satu baris
                maxLines: null, // Tidak ada batasan baris, otomatis bertambah
                keyboardType:
                    TextInputType.multiline, // Mengaktifkan mode multi-line
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: content,
                decoration: InputDecoration(labelText: 'note_content'.tr),
                onChanged: (value) => setState(() => content = value),
                maxLines:
                    null, // memungkinkan TextFormField otomatis membuat baris baru
                keyboardType: TextInputType
                    .multiline, // memungkinkan input beberapa baris
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_enter_content'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.note == null) {
                      await NotesDatabase.instance.create(
                        Note(
                          title: title,
                          content: content,
                        ),
                      );
                    } else {
                      await NotesDatabase.instance.update(
                        widget.note!.copyWith(
                          title: title,
                          content: content,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Warna teks
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Padding tombol
                  textStyle: TextStyle(
                    fontSize: 16, // Ukuran teks
                    fontWeight: FontWeight.bold, // Ketebalan teks
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // Radius sudut tombol
                  ),
                ),
                child: Text(widget.note == null ? 'save'.tr : 'update'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
