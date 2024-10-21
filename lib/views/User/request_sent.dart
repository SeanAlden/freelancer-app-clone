import 'package:flutter/material.dart';

// Mendefinisikan class "RequestSentPage" yang merupakan StatelessWidget
class RequestSentPage extends StatelessWidget {
  // Constructor "RequestSentPage" yang memanggil 'super' untuk menginisialisasi widget dengan key
  const RequestSentPage({super.key});

  // Metode 'build' untuk menggambarkan UI halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bagian Scaffold yang menyediakan struktur dasar untuk halaman seperti AppBar dan body
      appBar: AppBar(
        // AppBar dengan judul yang diposisikan di tengah
        title: const Center(
          child: Text(
            "Pending Approval", // Teks pada AppBar
          ),
        ),
      ),
      body: Container(
        // Container untuk memberikan padding pada isi halaman
        padding: const EdgeInsets.all(16),
        child: Column(
          // Pusatkan isi di tengah secara vertikal dan horizontal
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Menampilkan gambar dari asset
            Image.asset(
              'assets/images/wall-clock.png', // Lokasi gambar di folder assets
              width: 200, // Lebar gambar diatur menjadi 200
            ),
            const SizedBox(
              height: 64, // Memberi jarak vertikal sebesar 64 antara gambar dan teks
            ),
            // Menampilkan teks dengan gaya teks yang diambil dari tema aplikasi
            Text(
              "We're evaluating your profile", // Teks yang ditampilkan
              style: Theme.of(context).textTheme.titleMedium, // Menggunakan gaya teks 'titleMedium'
              textAlign: TextAlign.center, // Teks ditata di tengah
            ),
            const SizedBox(
              height: 16, // Memberi jarak vertikal sebesar 16 antara teks pertama dan teks kedua
            ),
            // Teks deskripsi dengan gaya yang lebih kecil
            Text(
              "In order to make our community holds up a standard, we don't allow any profiles to get in.", // Teks yang ditampilkan 
              style: Theme.of(context).textTheme.bodySmall, // Menggunakan gaya teks 'bodySmall'
              textAlign: TextAlign.center, // Teks ditata di tengah
            ),
          ],
        ),
      ),
    );
  }
}
