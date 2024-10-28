import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:clone_freelancer_mobile/views/Auth/login.dart';
import 'package:get/get.dart';

// SignUpPage class, menggunakan StatefulWidget untuk menampilkan halaman sign up
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Menggunakan TextEditingController untuk mengambil input dari user
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Variabel untuk mengontrol visibilitas password
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Inisialisasi AuthenticationController menggunakan GetX untuk mengelola state
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  // GlobalKey digunakan untuk mengidentifikasi form agar bisa divalidasi
  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk toggle visibilitas password
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Fungsi untuk toggle visibilitas konfirmasi password
  void _toggleConfirmVisibility() {
    setState(() {
      _obscureConfirm = !_obscureConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Menampilkan AppBar default
      body: Center(
        child: SingleChildScrollView(
          // Menggunakan SingleChildScrollView agar halaman bisa di-scroll jika terlalu panjang
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey, // Form key untuk validasi
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Menampilkan teks Sign Up sebagai judul halaman
                  Text(
                    'sign_up'.tr,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 30),

                  // TextFormField untuk input nama
                  TextFormField(
                    controller: _nameController,
                    obscureText: false, // Tidak menyembunyikan teks (nama)
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      labelText: 'name'.tr,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      // Validasi untuk memeriksa jika input kosong
                      if (value == null || value.trim().isEmpty) {
                        return 'name_required'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // TextFormField untuk input email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    obscureText: false, // Email tidak disembunyikan
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      labelText: 'email'.tr,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),
                    validator: (value) {
                      // Validasi jika email kosong
                      if (value == null || value.trim().isEmpty) {
                        return 'please_enter_email'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // TextFormField untuk input password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword, // Menyembunyikan password
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      labelText: 'password'.tr,
                      prefixIcon: const Icon(Icons.lock_outline),
                      // Icon untuk toggle visibilitas password
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      // Validasi jika password kosong atau kurang dari 8 karakter
                      if (value == null || value.trim().isEmpty) {
                        return 'please_enter_password'.tr;
                      } else if (value.length < 8) {
                        return 'pass_rule'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // TextFormField untuk konfirmasi password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText:
                        _obscureConfirm, // Menyembunyikan konfirmasi password
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      labelText: 'confirm_password'.tr,
                      prefixIcon: const Icon(Icons.lock_outline),
                      // Icon untuk toggle visibilitas konfirmasi password
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: _toggleConfirmVisibility,
                      ),
                    ),
                    validator: (value) {
                      // Validasi jika konfirmasi password kosong atau tidak sesuai
                      if (value == null || value.trim().isEmpty) {
                        return 'confirm_password_required'.tr;
                      } else if (value != _passwordController.text.trim()) {
                        return 'password_not_match'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Button untuk sign up
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Jika validasi form sukses
                            if (_formKey.currentState!.validate()) {
                              // Memanggil method sign up dari AuthenticationController
                              await _authenticationController.signUp(
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff6571ff)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          // Menggunakan Obx dari GetX untuk menampilkan indikator loading saat proses sign up berjalan
                          child: Obx(() {
                            return _authenticationController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'sign_up'.tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Menampilkan teks untuk login jika sudah memiliki akun
                  Get.previousRoute != '/LoginPage'
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'already_have_account'.tr,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              // Teks untuk login, menggunakan TapGestureRecognizer untuk navigasi ke halaman login
                              TextSpan(
                                text: 'login_here'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: const Color(0xff6571ff),
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => const LoginPage());
                                  },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
