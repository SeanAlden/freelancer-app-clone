import 'package:flutter/material.dart'; // Mengimpor paket yang berisi widget dasar dari Flutter
import 'package:clone_freelancer_mobile/core.dart'; // Mengimpor file 'core.dart' yang mungkin berisi fungsi atau widget yang digunakan di dalam aplikasi
import 'package:get/get.dart'; // Mengimpor paket GetX untuk manajemen state, routing, dan lainnya
import 'package:get_storage/get_storage.dart'; // Mengimpor GetStorage untuk penyimpanan lokal

// Deklarasi kelas StatefulWidget untuk halaman verifikasi notifikasi
class VerNoticePage extends StatefulWidget {
  const VerNoticePage({super.key, required this.choice}); 
  final String choice; // Menerima parameter 'choice' untuk menentukan pilihan yang dikirim ke halaman ini

  @override
  State<VerNoticePage> createState() => _VerNoticePageState(); // Menghubungkan state widget dengan _VerNoticePageState
}

// Deklarasi state dari VerNoticePage
class _VerNoticePageState extends State<VerNoticePage> {
  final box = GetStorage(); // Menggunakan GetStorage untuk menyimpan data secara lokal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold menyediakan struktur dasar untuk tampilan halaman
      body: Center(
        child: SingleChildScrollView(
          // Membungkus konten agar bisa discroll jika melebihi ukuran layar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30), // Menambahkan padding horizontal di kiri dan kanan
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Konten ditata di tengah
              children: [
                Image.asset(
                  'assets/images/confirmed.jpg', // Menampilkan gambar dari asset
                  width: 200, // Mengatur lebar gambar
                ),
                const SizedBox(
                  height: 20, // Menambahkan jarak vertikal sebesar 20
                ),
                Text(
                  'register_feedback'.tr, // Menampilkan teks sebagai judul utama
                  style: Theme.of(context).textTheme.headlineLarge, // Menggunakan gaya teks yang ada dalam tema
                  textAlign: TextAlign.center, // Teks ditata di tengah secara horizontal
                ),
                const SizedBox(
                  height: 20, // Menambahkan jarak vertikal sebesar 20
                ),
                Text(
                  'confirm_email'.tr, // Teks instruksi konfirmasi email
                  textAlign: TextAlign.center, // Teks ditata di tengah
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600], // Mengatur warna teks menjadi abu-abu
                      ),
                ),
                const SizedBox(
                  height: 30, // Menambahkan jarak vertikal sebesar 30
                ),
                Row(
                  children: [
                    Expanded(
                      // Menggunakan Expanded untuk membuat tombol memenuhi lebar yang tersedia
                      child: ElevatedButton(
                        onPressed: () async {
                          // Ketika tombol ditekan
                          if (widget.choice == '1') {
                            // Jika parameter choice bernilai '1', navigasi ke halaman Login
                            Get.off(() => const LoginPage()); // Mengganti halaman saat ini dengan LoginPage menggunakan GetX
                          } else {
                            Get.back(); // Jika bukan '1', kembali ke halaman sebelumnya
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff6571ff)), // Mengatur warna latar belakang tombol
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Membuat tombol dengan sudut melengkung
                            ),
                          ),
                        ),
                        child: Text(
                          'back_to_login'.tr, // Teks di dalam tombol
                          style: TextStyle(
                            color: Colors.white, // Mengatur warna teks menjadi putih
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
