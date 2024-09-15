import 'package:url_launcher/url_launcher.dart';
// Mengimpor package 'url_launcher' yang digunakan untuk membuka URL dari aplikasi, seperti membuka tautan ke Google Maps.

class MapUtils {
  MapUtils._();
  // Membuat konstruktor privat (MapUtils._()) untuk mencegah instansiasi langsung dari kelas MapUtils.
  // Kelas ini hanya berfungsi sebagai kumpulan metode statis.

  static Future<void> openMap(double latitude, double longitude) async {
    // Metode statis untuk membuka Google Maps dengan koordinat latitude dan longitude.
    // Menggunakan Future<void> karena metode ini asinkron dan tidak mengembalikan nilai.

    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // Mengonstruksi URL Google Maps menggunakan latitude dan longitude yang diterima sebagai parameter.

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      // Memeriksa apakah URL yang telah di-parse dapat diluncurkan.

      await launchUrl(Uri.parse(googleUrl));
      // Jika bisa, maka meluncurkan URL menggunakan metode launchUrl yang akan membuka Google Maps.
    } else {
      throw 'Could not open the map.';
      // Jika URL tidak bisa dibuka, maka menampilkan pesan error.
    }
  }
}
