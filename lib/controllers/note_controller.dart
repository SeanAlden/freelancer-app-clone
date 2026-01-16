import 'dart:convert';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/notes.dart';

class NoteController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final box = GetStorage();

  Map<String, String> get headers => {
        'Authorization': 'Bearer ${box.read('token')}',
        'Accept': 'application/json',
      };

  Future<void> fetchNotes() async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('${url}notes'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      notes.value = data.map((e) => Note.fromMap(e)).toList();
    }
    isLoading.value = false;
  }

  Future<void> addNote(String title, String content) async {
    await http.post(
      Uri.parse('${url}notes'),
      headers: headers,
      body: {
        'title': title,
        'content': content,
      },
    );
    fetchNotes();
  }

  // Future<void> updateNote(Note note) async {
  //   await http.put(
  //     Uri.parse('${url}notes/${note.id}'),
  //     headers: headers,
  //     body: note.toMap(),
  //   );
  //   fetchNotes();
  // }

  // Future<void> updateNote(Note note) async {
  //   await http.put(
  //     Uri.parse('$url/notes/${note.id}'),
  //     headers: {
  //       ...headers,
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       'title': note.title,
  //       'content': note.content,
  //     }),
  //   );

  //   fetchNotes();
  // }

  Future<void> updateNote(Note note) async {
    await http.put(
      Uri.parse('${url}notes/${note.id}'),
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
      body: jsonEncode({
        'title': note.title,
        'content': note.content,
      }),
    );

    fetchNotes();
  }
  
  Future<void> deleteNote(int id) async {
    await http.delete(
      Uri.parse('${url}notes/$id'),
      headers: headers,
    );
    fetchNotes();
  }
}
