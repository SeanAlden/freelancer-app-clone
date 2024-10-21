// import 'package:clone_freelancer_mobile/controllers/notes_database.dart';
// import 'package:clone_freelancer_mobile/core.dart';
// import 'package:clone_freelancer_mobile/models/notes.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotesPage extends StatefulWidget {
//   @override
//   _NotesPageState createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   late List<Note> notes = [];
//   bool isLoading = false;
//   String? userId;

//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }

//   Future checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     userId = prefs.getString('userId');

//     if (!isLoggedIn || userId == null) {
//       // Jika user belum login, tampilkan peringatan dan kembalikan ke halaman login
//       showLoginWarning();
//     } else {
//       refreshNotes();
//     }
//   }

//   void showLoginWarning() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Warning'),
//           content: Text('Anda belum login, catatan tidak dapat dibuka!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Navigator.pushReplacementNamed(context, '/loginPage');
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => LoginPage(),
//                 ));
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future refreshNotes() async {
//     setState(() => isLoading = true);

//     if (userId != null) {
//       this.notes = await NotesDatabase.instance.readAllNotes(userId!);
//     }

//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : notes.isEmpty
//               ? Center(child: Text('No Notes'))
//               : buildNotes(),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => AddEditNotePage(),
//           ));
//           refreshNotes();
//         },
//       ),
//     );
//   }

//   Widget buildNotes() => ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];

//           return Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               title: Text(note.title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               subtitle: Text(
//                 note.content,
//                 style: TextStyle(color: Colors.grey[600]),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               onTap: () async {
//                 await Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => AddEditNotePage(note: note),
//                 ));
//                 refreshNotes();
//               },
//               trailing: IconButton(
//                 icon: Icon(Icons.delete, color: Colors.red),
//                 onPressed: () => showDeleteConfirmationDialog(note),
//               ),
//             ),
//           );
//         },
//       );

//   void showDeleteConfirmationDialog(Note note) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Delete Note'),
//           content: Text('Do you want to delete this note?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await NotesDatabase.instance.delete(note.id!);
//                 Navigator.of(context).pop();
//                 refreshNotes();
//               },
//               child: Text('Yes', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:clone_freelancer_mobile/controllers/auth_service.dart';
import 'package:clone_freelancer_mobile/controllers/notes_database.dart';
import 'package:clone_freelancer_mobile/models/notes.dart';
import 'package:flutter/material.dart';

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
    // checkLoginStatus();
  }

  // Future<void> checkLoginStatus() async {
  //   userEmail = await AuthService().getCurrentUser();

  //   if (userEmail == null) {
  //     showLoginWarning();
  //   } else {
  //     refreshNotes();
  //   }
  // }

  // void showLoginWarning() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Warning'),
  //         content: Text('Anda belum login, catatan tidak dapat dibuka!'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  // Future refreshNotes() async {
  //   setState(() => isLoading = true);

  //   if (userEmail != null) {
  //     this.notes = await NotesDatabase.instance.readAllNotes(userEmail!);
  //   }

  //   setState(() => isLoading = false);
  // }

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
        title: const Text(
          'Notes', // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(child: Text('No Notes'))
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
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: userEmail == null
      //       ? null
      //       : () async {
      //           await Navigator.of(context).push(MaterialPageRoute(
      //             builder: (context) => AddEditNotePage(
      //                 userEmail: userEmail!), // userEmail dikirimkan
      //           ));
      //           refreshNotes();
      //         },
      // ),
    );
  }

  // Widget buildNotes() => ListView.builder(
  //       itemCount: notes.length,
  //       itemBuilder: (context, index) {
  //         final note = notes[index];

  //         return Card(
  //           elevation: 4,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: ListTile(
  //             title: Text(note.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             subtitle: Text(
  //               note.content,
  //               style: TextStyle(color: Colors.grey[600]),
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //             onTap: () async {
  //               await Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) => AddEditNotePage(note: note),
  //               ));
  //               refreshNotes();
  //             },
  //             trailing: IconButton(
  //               icon: Icon(Icons.delete, color: Colors.red),
  //               onPressed: () => showDeleteConfirmationDialog(note),
  //             ),
  //           ),
  //         );
  //       },
  //     );

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
                // onTap: () async {
                //   await Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => Hero(
                //         tag: 'note_${note.id}',
                //         child: AddEditNotePage(note: note),
                //       ),
                //     ),
                //   );
                //   refreshNotes();
                // },
                // onTap: () async {
                //   await Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => AddEditNotePage(
                //         note: note,
                //         userEmail: userEmail!), // userEmail dikirimkan
                //   ));
                //   refreshNotes();
                // },
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
          title: Text('Delete Note'),
          content: Text('Do you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await NotesDatabase.instance.delete(note.id!);
                Navigator.of(context).pop(); // Close the dialog
                refreshNotes(); // Refresh notes list after deletion
              },
              child: Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:clone_freelancer_mobile/controllers/notes_database.dart';
// import 'package:clone_freelancer_mobile/models/notes.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => ThemeNotifier(),
//       child: Consumer<ThemeNotifier>(
//         builder: (context, theme, _) {
//           return MaterialApp(
//             theme: theme.getLightTheme(),
//             darkTheme: theme.getDarkTheme(),
//             themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
//             home: NotesPage(),
//           );
//         },
//       ),
//     );
//   }
// }

// class NotesPage extends StatefulWidget {
//   @override
//   _NotesPageState createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   late List<Note> notes;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     refreshNotes();
//   }

//   Future refreshNotes() async {
//     setState(() => isLoading = true);
//     this.notes = await NotesDatabase.instance.readAllNotes();
//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//         actions: [
//           Switch(
//             value: themeNotifier.isDarkMode,
//             onChanged: (value) {
//               themeNotifier.toggleTheme();
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : notes.isEmpty
//               ? Center(child: Text('No Notes'))
//               : buildNotes(),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => AddEditNotePage(),
//           ));
//           refreshNotes();
//         },
//       ),
//     );
//   }

//   Widget buildNotes() => ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];

//           return Dismissible(
//             key: ValueKey(note.id),
//             background: Container(
//               color: Colors.redAccent,
//               alignment: Alignment.centerRight,
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Icon(Icons.delete, color: Colors.white),
//             ),
//             direction: DismissDirection.endToStart,
//             onDismissed: (direction) async {
//               await NotesDatabase.instance.delete(note.id!);
//               refreshNotes();
//             },
//             child: Card(
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   child:
//                       Text(note.title[0]), // Avatar berisi huruf pertama judul
//                 ),
//                 title: Text(
//                   note.title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   note.content,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 onTap: () async {
//                   await Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => Hero(
//                         tag: 'note_${note.id}',
//                         child: AddEditNotePage(note: note),
//                       ),
//                     ),
//                   );
//                   refreshNotes();
//                 },
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => showDeleteConfirmationDialog(note),
//                 ),
//               ),
//             ),
//           );
//         },
//       );

//   // Function to show delete confirmation dialog
//   void showDeleteConfirmationDialog(Note note) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Delete Note'),
//           content: Text('Do you want to delete this note?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 await NotesDatabase.instance.delete(note.id!);
//                 Navigator.of(context).pop();
//                 refreshNotes();
//               },
//               child: Text('Yes', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class ThemeNotifier with ChangeNotifier {
//   bool isDarkMode = false;

//   void toggleTheme() {
//     isDarkMode = !isDarkMode;
//     notifyListeners();
//   }

//   ThemeData getLightTheme() {
//     return ThemeData(
//       brightness: Brightness.light,
//       primaryColor: Colors.blue,
//       appBarTheme: AppBarTheme(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: Colors.blue,
//       ),
//     );
//   }

//   ThemeData getDarkTheme() {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: Colors.grey[900],
//       appBarTheme: AppBarTheme(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//         backgroundColor: Colors.grey[700],
//       ),
//     );
//   }
// }

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
  // late String userEmail;

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
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      //     AppBar(
      //   title: Hero(
      //     tag: 'note_${widget.note?.id}',
      //     child: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      //   ),
      // ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Form(
      //     key: _formKey,
      //     child: Column(
      //       children: [
      //         // TextFormField(
      //         //   initialValue: title,
      //         //   decoration: InputDecoration(labelText: 'Title'),
      //         //   onChanged: (value) => setState(() => title = value),
      //         //   validator: (value) {
      //         //     if (value == null || value.isEmpty) {
      //         //       return 'Please enter a title';
      //         //     }
      //         //     return null;
      //         //   },
      //         // ),
      //         TextFormField(
      //           initialValue: title,
      //           decoration: InputDecoration(labelText: 'Title'),
      //           onChanged: (value) => setState(() => title = value),
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return 'Please enter a title';
      //             }
      //             return null;
      //           },
      //           // Mengizinkan teks berpindah ke baris berikutnya
      //           minLines: 1, // Minimal satu baris
      //           maxLines:
      //               null, // Tidak ada batasan baris, akan otomatis bertambah
      //           keyboardType:
      //               TextInputType.multiline, // Mengaktifkan mode multi-line
      //         ),
      //         // TextFormField(
      //         //   initialValue: content,
      //         //   decoration: InputDecoration(labelText: 'Content'),
      //         //   onChanged: (value) => setState(() => content = value),
      //         //   validator: (value) {
      //         //     if (value == null || value.isEmpty) {
      //         //       return 'Please enter content';
      //         //     }
      //         //     return null;
      //         //   },
      //         // ),
      //         TextFormField(
      //           initialValue: content,
      //           decoration: InputDecoration(labelText: 'Content'),
      //           onChanged: (value) => setState(() => content = value),
      //           maxLines:
      //               null, // memungkinkan TextFormField untuk otomatis membuat baris baru
      //           keyboardType: TextInputType
      //               .multiline, // memungkinkan input beberapa baris
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return 'Please enter content';
      //             }
      //             return null;
      //           },
      //         ),
      //         SizedBox(height: 20),
      //         // ElevatedButton(
      //         //   onPressed: () async {
      //         //     if (_formKey.currentState!.validate()) {
      //         //       if (widget.note == null) {
      //         //         await NotesDatabase.instance.create(
      //         //           Note(
      //         //             title: title,
      //         //             content: content,
      //         //           ),
      //         //         );
      //         //       } else {
      //         //         await NotesDatabase.instance.update(
      //         //           widget.note!.copyWith(
      //         //             title: title,
      //         //             content: content,
      //         //           ),
      //         //         );
      //         //       }
      //         //       Navigator.of(context).pop();
      //         //     }
      //         //   },
      //         //   child: Text(widget.note == null ? 'Save' : 'Update'),
      //         // )
      //         ElevatedButton(
      //           onPressed: () async {
      //             if (_formKey.currentState!.validate()) {
      //               if (widget.note == null) {
      //                 await NotesDatabase.instance.create(
      //                   Note(
      //                     title: title,
      //                     content: content,
      //                   ),
      //                 );
      //               } else {
      //                 await NotesDatabase.instance.update(
      //                   widget.note!.copyWith(
      //                     title: title,
      //                     content: content,
      //                   ),
      //                 );
      //               }
      //               Navigator.of(context).pop();
      //             }
      //           },
      //           style: ElevatedButton.styleFrom(
      //             foregroundColor: Colors.white,
      //             backgroundColor: Colors.blue, // Warna teks
      //             padding: EdgeInsets.symmetric(
      //                 horizontal: 20, vertical: 15), // Padding tombol
      //             textStyle: TextStyle(
      //               fontSize: 16, // Ukuran teks
      //               fontWeight: FontWeight.bold, // Ketebalan teks
      //             ),
      //             shape: RoundedRectangleBorder(
      //               borderRadius:
      //                   BorderRadius.circular(12), // Radius sudut tombol
      //             ),
      //           ),
      //           child: Text(widget.note == null ? 'Save' : 'Update'),
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => setState(() => title = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
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
                decoration: InputDecoration(labelText: 'Content'),
                onChanged: (value) => setState(() => content = value),
                maxLines:
                    null, // memungkinkan TextFormField otomatis membuat baris baru
                keyboardType: TextInputType
                    .multiline, // memungkinkan input beberapa baris
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
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
                          // userEmail: userEmail,
                          // userEmail: userEmail
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
                child: Text(widget.note == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
