class Occupation {
  // Deklarasi variabel untuk menyimpan nama pekerjaan, tanggal mulai ('from'), dan tanggal berakhir ('to')
  String occupation;
  String from;
  String to;

  // Konstruktor untuk menginisialisasi field occupation, from, dan to dengan nilai yang diperlukan
  Occupation({required this.occupation, required this.from, required this.to});

  // Metode untuk mengubah instance dari Occupation menjadi map yang kompatibel dengan JSON
  Map<String, dynamic> toJson() {
    return {
      'occupation': occupation, // Mengubah field 'occupation' menjadi pasangan key-value
      'from': from, // Mengubah field 'from' menjadi pasangan key-value
      'to': to, // Mengubah field 'to' menjadi pasangan key-value
    };
  }
}
