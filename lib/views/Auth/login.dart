import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:clone_freelancer_mobile/views/Auth/forgot_password.dart';
import 'package:clone_freelancer_mobile/views/Auth/signup.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widget LoginPage merupakan halaman login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Menggunakan controller untuk mengambil input email dan password dari user
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variabel untuk menyembunyikan atau menampilkan password
  bool _obscureText = true;

  // Memanggil AuthenticationController menggunakan GetX untuk mengelola logika autentikasi
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  // GlobalKey digunakan untuk memvalidasi form
  final _formKey = GlobalKey<FormState>();

  // Fungsi untuk toggle visibilitas password
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // void login() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String email = _emailController.text.trim();

  //   if (email.isNotEmpty) {
  //     // Simpan status login dan userId di SharedPreferences
  //     await prefs.setBool('isLoggedIn', true);
  //     await prefs.setString('userId', email);

  //     // Navigasi ke halaman catatan atau halaman utama
  //     Navigator.pushReplacementNamed(context, '/notesPage');
  //   } else {
  //     // Tampilkan pesan error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Username cannot be empty')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Membuat AppBar kosong di bagian atas
      body: Center(
        child: Form(
          key: _formKey, // Menggunakan _formKey untuk memvalidasi input form
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30), // Padding untuk menyesuaikan jarak
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Konten di tengah secara vertikal
              children: [
                Text(
                  'login_title'.tr, // Judul halaman Login
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // TextFormField untuk input email
                TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // Menentukan tipe input sebagai email
                  controller: _emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    labelText: 'email'.tr,
                    prefixIcon: const Icon(
                        Icons.mail_outline), // Icon pada bagian kiri input
                  ),
                  // Validator untuk memastikan email tidak kosong
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please_enter_email'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // TextFormField untuk input password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText, // Tampilkan/hide password
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    labelText: 'password'.tr,
                    prefixIcon: const Icon(
                        Icons.lock_outline), // Icon kunci untuk password
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed:
                          _togglePasswordVisibility, // Fungsi untuk toggle visibilitas password
                    ),
                  ),
                  // Validator untuk memastikan password tidak kosong
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please_enter_password'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // Link untuk Forgot Password di bagian kanan
                Align(
                  alignment: Alignment.centerRight, // Align konten ke kanan
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'forgot_password'.tr,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xff6571ff),
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() =>
                                  const ForgotPasswordPage()); // Arahkan ke halaman forgot password
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Button Login
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Jika form valid, maka proses login
                            await _authenticationController.logIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff6571ff)), // Warna button
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        // Menampilkan loading jika sedang memproses login
                        child: Obx(() {
                          return _authenticationController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'login'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Link untuk menuju halaman Sign Up jika belum memiliki akun
                Get.previousRoute != '/SignUpPage'
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'dont_have_account'.tr,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: 'sign_up'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: const Color(
                                        0xff6571ff), // Warna teks "Sign Up"
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() =>
                                      const SignUpPage()); // Arahkan ke halaman Sign Up
                                },
                            ),
                          ],
                        ),
                      )
                    : Container(), // Kosongkan jika sudah berada di halaman Sign Up
              ],
            ),
          ),
        ),
      ),
    );
  }
}
