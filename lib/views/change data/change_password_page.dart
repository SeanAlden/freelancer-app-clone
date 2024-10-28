import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:get/get.dart';

// Class untuk merubah password
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

// State dari class untuk merubah password
class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final UserController userController = Get.put(UserController());
  final _formKey = GlobalKey<FormState>();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  void _togglePasswordVisibility(int index) {
    setState(() {
      if (index == 1) {
        _obscureText1 = !_obscureText1;
      } else if (index == 2) {
        _obscureText2 = !_obscureText2;
      } else {
        _obscureText3 = !_obscureText3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // mengatur title pada halaman
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'change_password'.tr, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      // scroll view pada bagian mengisi password
      body: SingleChildScrollView(
        child: Container(
          // bagian untuk mengatur konten merubah password
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Password sekarang
                Text(
                  'current_password'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: currentController,
                  obscureText: _obscureText1,
                  decoration: InputDecoration(
                    hintText: 'current_password'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _togglePasswordVisibility(1);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'current_password_required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                // Password baru
                Text(
                  'new_password'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: newController,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    hintText: 'new_password'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _togglePasswordVisibility(2);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_new_password'.tr;
                    } else if (value.length < 8) {
                      return 'pass_rule'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                // Konfirmasi Password Baru
                Text(
                  'confirm_password'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: confirmController,
                  obscureText: _obscureText3,
                  decoration: InputDecoration(
                    hintText: 'confirm_password'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText3 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _togglePasswordVisibility(3);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'confirm_password_required'.tr;
                    } else if (value != newController.text.trim()) {
                      return 'password_not_match'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      // tombol save
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            await userController.changePassword(
                              newPassword: newController.text.trim(),
                              currentPassword: currentController.text.trim(),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Obx(() {
                          return userController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'save'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
