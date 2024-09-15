import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:clone_freelancer_mobile/views/Auth/forgot_password.dart';
import 'package:clone_freelancer_mobile/views/Auth/signup.dart';
import 'package:get/get.dart';

// Widget LoginPage merupakan halaman login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Menggunakan controller untuk mengambil input email dan password dari user
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
                  'Login', // Judul halaman Login
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
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
                    labelText: 'Email',
                    prefixIcon: const Icon(
                        Icons.mail_outline), // Icon pada bagian kiri input
                  ),
                  // Validator untuk memastikan email tidak kosong
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
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
                    labelText: 'Password',
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
                      return 'Please enter your password';
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
                          text: "Forgot Password",
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
                              : const Text(
                                  "Login",
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
                              text: "Don't have an account ? ",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: "Sign Up",
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
