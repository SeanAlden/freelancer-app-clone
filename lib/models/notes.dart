class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Convert Note object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Convert Map to Note object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }

  // Add copyWith method
  Note copyWith({
    int? id,
    String? title,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

// class Note {
//   int? id;
//   String title;
//   String content;
//   String userEmail; // Menyimpan email user yang login

//   Note({
//     this.id,
//     required this.title,
//     required this.content,
//     required this.userEmail, // Pastikan setiap catatan dikaitkan dengan user
//   });

//   // Convert Note object to Map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'content': content,
//       'userEmail': userEmail, // Menyimpan email user ke dalam database
//     };
//   }

//   // Convert Map to Note object
//   factory Note.fromMap(Map<String, dynamic> map) {
//     return Note(
//       id: map['id'],
//       title: map['title'],
//       content: map['content'],
//       userEmail: map['userEmail'], // Mengambil email user dari database
//     );
//   }

//   // Add copyWith method
//   Note copyWith({
//     int? id,
//     String? title,
//     String? content,
//     String? userEmail,
//   }) {
//     return Note(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       content: content ?? this.content,
//       userEmail: userEmail ?? this.userEmail,
//     );
//   }
// }