import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:get/get.dart';

// Halaman untuk mengatur password baru, memerlukan email dan token untuk proses reset
class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key, required this.email, required this.token});
  final String email; // Email pengguna
  final String token; // Token untuk reset password

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  // Membuat instance AuthenticationController untuk menangani reset password
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  // TextEditingController untuk mengontrol input password dan konfirmasi password
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  // Key untuk form validasi
  final _formKey = GlobalKey<FormState>();

  // Boolean untuk menyembunyikan atau menampilkan password
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  // Fungsi untuk toggle visibilitas password dan konfirmasi password
  void _togglePasswordVisibility(int index) {
    setState(() {
      if (index == 1) {
        _obscureText1 = !_obscureText1; // Toggle visibilitas password
      } else {
        _obscureText2 =
            !_obscureText2; // Toggle visibilitas konfirmasi password
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // AppBar default
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 30), // Padding untuk memberikan jarak horizontal
          child: Form(
            key: _formKey, // Menggunakan form untuk validasi input
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center, // Pusatkan konten di tengah layar
              children: [
                Align(
                  alignment: Alignment
                      .center, // Mencentralkan teks di bagian atas halaman
                  child: Text(
                    'Set New Password',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // Warna teks untuk mode gelap
                              : Colors.black, // Warna teks untuk mode terang
                        ),
                    textAlign: TextAlign.center, // Teks rata tengah
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Must be at least 8 characters", // Petunjuk tambahan
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors
                              .grey[600], // Warna abu-abu untuk teks petunjuk
                        ),
                  ),
                ),
                const SizedBox(
                  height: 30, // Memberikan jarak antar elemen
                ),
                Text(
                  'New Password', // Label untuk input password baru
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8, // Jarak antara label dan input field
                ),
                // Input field untuk password baru
                TextFormField(
                  controller: passwordController, // Mengontrol input password
                  obscureText: _obscureText1, // Password akan disembunyikan
                  decoration: InputDecoration(
                    hintText: "New Password", // Placeholder pada input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Membuat border input rounded
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1
                            ? Icons.visibility
                            : Icons
                                .visibility_off, // Ikon untuk toggle visibilitas password
                      ),
                      onPressed: () {
                        _togglePasswordVisibility(
                            1); // Mengubah visibilitas password
                      },
                    ),
                  ),
                  // Validasi input password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password'; // Pesan error jika kosong
                    } else if (value.trim().length < 8) {
                      return 'Password length must be at least 8 characters'; // Pesan error jika kurang dari 8 karakter
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16, // Jarak antara password dan konfirmasi password
                ),
                Text(
                  'Confirm Password', // Label untuk input konfirmasi password
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                // Input field untuk konfirmasi password
                TextFormField(
                  controller:
                      confirmController, // Mengontrol input konfirmasi password
                  obscureText: _obscureText2, // Password akan disembunyikan
                  decoration: InputDecoration(
                    hintText:
                        "Confirm Password", // Placeholder pada input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Membuat border input rounded
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2
                            ? Icons.visibility
                            : Icons
                                .visibility_off, // Ikon untuk toggle visibilitas konfirmasi password
                      ),
                      onPressed: () {
                        _togglePasswordVisibility(
                            2); // Mengubah visibilitas konfirmasi password
                      },
                    ),
                  ),
                  // Validasi input konfirmasi password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password confirmation'; // Pesan error jika kosong
                    } else if (value != passwordController.text.trim()) {
                      return 'Passwords do not match'; // Pesan error jika password tidak sama
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height:
                      30, // Jarak antara konfirmasi password dan tombol reset
                ),
                Row(
                  children: [
                    // Tombol untuk reset password
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Jika validasi form berhasil, panggil fungsi reset password
                            await _authenticationController.reset(
                              email: widget.email,
                              password: passwordController.text.trim(),
                              token: widget.token,
                            );
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Border tombol dibuat rounded
                            ),
                          ),
                        ),
                        // Tampilkan loading atau teks berdasarkan status isLoading dari controller
                        child: Obx(() {
                          return _authenticationController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors
                                        .white, // Loading spinner saat proses reset berlangsung
                                  ),
                                )
                              : const Text(
                                  "Reset Password", // Teks tombol
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
