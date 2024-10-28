import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// Kelas ResetPassword adalah StatefulWidget untuk halaman reset password yang menerima parameter email
class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required this.email});
  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

// State dari ResetPassword untuk mengelola status halaman
class _ResetPasswordState extends State<ResetPassword> {
  // Menginisialisasi controller untuk autentikasi
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  // Menginisialisasi TextEditingController untuk input PIN
  TextEditingController pinController = TextEditingController();
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar standar untuk halaman
      appBar: AppBar(),
      body: Center(
        child: Padding(
          // Memberikan padding horizontal untuk form
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey, // Mengaitkan form dengan _formKey untuk validasi
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Konten berada di tengah secara vertikal
              children: [
                // Menampilkan judul halaman
                Text(
                  'reset_password'.tr,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // Warna teks untuk mode gelap
                            : Colors.black, // Warna teks untuk mode terang
                      ),
                  textAlign: TextAlign.center, // Teks rata tengah
                ),
                const SizedBox(
                  height: 16,
                ),
                // Menampilkan teks yang menginformasikan pengguna bahwa kode verifikasi telah dikirim
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'we_sent_verification_code'.tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      // Menampilkan email yang dimasukkan oleh pengguna
                      TextSpan(
                        text: widget.email,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // PinCodeTextField untuk memasukkan kode verifikasi (PIN)
                PinCodeTextField(
                  appContext: context,
                  length: 4, // Panjang kode PIN adalah 4 digit
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape
                        .underline, // Bentuk underline untuk setiap kotak PIN
                    selectedColor:
                        const Color(0xff6571ff), // Warna untuk kotak terpilih
                    inactiveColor: Colors.grey, // Warna untuk kotak tidak aktif
                  ),
                  controller:
                      pinController, // Controller untuk mengatur input teks
                  keyboardType:
                      TextInputType.number, // Menggunakan keyboard angka
                  // Memanggil checkCode ketika kode verifikasi selesai diinput
                  onCompleted: (value) async {
                    await _authenticationController.checkCode(
                      email: widget.email,
                      token: pinController.text.trim(),
                    );
                  },
                  // Validator untuk memastikan PIN diinput dan panjangnya 4 digit
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'pin_request'.tr;
                    }
                    if (v.length != 4) {
                      return 'pin_validator'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    // Tombol "Continue" untuk melanjutkan proses setelah input PIN divalidasi
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validasi form, jika valid, memeriksa kode verifikasi
                          if (_formKey.currentState!.validate()) {
                            await _authenticationController.checkCode(
                              email: widget.email,
                              token: pinController.text.trim(),
                            );
                          }
                        },
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
                        // Obx digunakan untuk mengamati perubahan status isLoading di AuthenticationController
                        child: Obx(() {
                          // Menampilkan CircularProgressIndicator jika isLoading = true
                          return _authenticationController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'continue'.tr,
                                );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // RichText dengan opsi untuk mengirim ulang email verifikasi
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'not_receive_email'.tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      // TextSpan interaktif dengan TapGestureRecognizer untuk memicu pengiriman ulang email
                      TextSpan(
                        text: 'click_here'.tr,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: const Color(0xff6571ff),
                            ),
                        recognizer: TapGestureRecognizer()
                          // Saat diklik, mengirim ulang email verifikasi
                          ..onTap = () async {
                            await _authenticationController.forgot(
                              email: widget.email,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
