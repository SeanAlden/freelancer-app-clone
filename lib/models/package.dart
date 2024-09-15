class Package {
  // Deklarasi variabel anggota dari class Package
  // 'int?' menunjukkan bahwa id bisa bernilai null
  int? id;

  // 'title', 'desc', 'price', 'deliveryDays', dan 'revision' wajib diisi dan nilainya tidak bisa null
  String title;
  String desc;
  int price;
  int deliveryDays;
  int revision;

  // Constructor class Package untuk menginisialisasi properti dengan nilai yang diperlukan
  Package({
    required this.id, // 'required' berarti nilai ini wajib diberikan saat pembuatan objek, walaupun bisa null
    required this.title, // Title wajib diberikan
    required this.desc, // Deskripsi wajib diberikan
    required this.price, // Harga wajib diberikan
    required this.deliveryDays, // Jumlah hari pengiriman wajib diberikan
    required this.revision, // Jumlah revisi yang diizinkan wajib diberikan
  });

  // Fungsi toJson() untuk mengubah objek Package menjadi representasi Map (key-value)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Konversi properti 'id' ke dalam format key-value
      'title': title, // Konversi properti 'title' ke dalam format key-value
      'desc': desc, // Konversi properti 'desc' ke dalam format key-value
      'price': price, // Konversi properti 'price' ke dalam format key-value
      'deliveryDays':
          deliveryDays, // Konversi properti 'deliveryDays' ke dalam format key-value
      'revision':
          revision, // Konversi properti 'revision' ke dalam format key-value
    };
  }
}
