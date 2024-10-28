import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:get/get.dart';

// Kelas utama ForgotPasswordPage yang akan digunakan untuk membangun halaman
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

// Kelas state yang mengelola status dan logika dari halaman ForgotPasswordPage
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // TextEditingController untuk mengontrol input email
  final TextEditingController _emailController = TextEditingController();

  // Menghubungkan AuthenticationController dari GetX untuk autentikasi
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  // GlobalKey untuk mengontrol validasi form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar di bagian atas halaman
      appBar: AppBar(),

      // Body halaman dengan elemen di tengah layar
      body: Center(
        child: Padding(
          // Padding horizontal untuk memberi jarak dari tepi
          padding: const EdgeInsets.symmetric(horizontal: 30),

          // Form yang membungkus TextFormField dan tombol
          child: Form(
            key: _formKey, // Menghubungkan form dengan _formKey untuk validasi
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Menempatkan elemen di tengah secara vertikal
              children: [
                // Judul halaman
                Text(
                  'forgot_password_title'.tr,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // Warna teks untuk mode gelap
                            : Colors.black, // Warna teks untuk mode terang
                      ),
                  textAlign: TextAlign.center, // Teks rata tengah
                ),
                // Text(
                //   'Forgot Password ?',
                //   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                //         color: Colors.black, // Warna teks hitam
                //       ),
                //   textAlign: TextAlign.center, // Teks rata tengah
                // ),
                const SizedBox(
                  height: 16, // Jarak vertikal antara elemen
                ),

                // Instruksi kepada pengguna
                Text(
                  'please_enter_your_email'.tr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600], // Warna teks abu-abu
                      ),
                  textAlign: TextAlign.center, // Teks rata tengah
                ),
                const SizedBox(
                  height: 30, // Jarak vertikal lebih besar antara elemen
                ),

                // Input field untuk email
                TextFormField(
                    keyboardType: TextInputType
                        .emailAddress, // Jenis input berupa alamat email
                    controller:
                        _emailController, // Menghubungkan dengan controller email
                    obscureText:
                        false, // Tidak menyembunyikan teks (karena ini bukan password)

                    // Dekorasi untuk input field
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            16.0), // Membuat sudut border melengkung
                      ),
                      labelText: 'email'.tr, // Label dalam input field
                      prefixIcon: const Icon(Icons
                          .mail_outline), // Ikon di bagian kiri input field
                    ),

                    // Validasi input email
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'please_enter_email'.tr; // Pesan kesalahan jika email kosong
                      }
                      return null; // Validasi sukses jika tidak ada masalah
                    }),
                const SizedBox(
                  height: 30, // Jarak vertikal antara elemen
                ),

                // Baris yang berisi tombol reset password
                Row(
                  children: [
                    // Tombol untuk mengirim permintaan reset password
                    Expanded(
                      child: ElevatedButton(
                        // Logika yang dijalankan saat tombol ditekan
                        onPressed: () async {
                          // Mengecek validasi form
                          if (_formKey.currentState!.validate()) {
                            // Memanggil fungsi forgot dari AuthenticationController untuk memproses reset password
                            await _authenticationController.forgot(
                              email: _emailController.text
                                  .trim(), // Mengambil input email dan memotong spasi
                            );
                          }
                        },

                        // Gaya tombol
                        style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue), // Warna latar belakang
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Warna teks atau ikon
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),

                        // Menggunakan Obx untuk memantau perubahan isLoading dari AuthenticationController
                        child: Obx(() {
                          // Jika isLoading true, tampilkan CircularProgressIndicator, jika tidak tampilkan teks "Reset Password"
                          return _authenticationController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors
                                        .white, // Indikator loading berwarna putih
                                  ),
                                )
                              : Text(
                                  'reset_password'.tr, // Teks tombol saat tidak loading
                                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white),
                                );
                        }),
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
