class UserData {
  int userId; // Menyimpan ID pengguna, bertipe int
  String? piclink; // Menyimpan link gambar profil pengguna, bisa null
  String name; // Menyimpan nama pengguna, bertipe String

  // Constructor untuk inisialisasi variabel userId, piclink, dan name
  UserData({
    required this.userId, // userId wajib diisi (required)
    required this.piclink, // piclink juga wajib diisi, meskipun bisa null
    required this.name, // name wajib diisi (required)
  });
}

class PictureUrl {
  String picture1; // Menyimpan URL untuk gambar pertama
  String picture2; // Menyimpan URL untuk gambar kedua

  // Constructor untuk inisialisasi variabel picture1 dan picture2
  PictureUrl({
    required this.picture1, // picture1 wajib diisi (required)
    required this.picture2, // picture2 juga wajib diisi (required)
  });
}
