import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// class untuk mengatur perubahan nama akun dan email
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

// state dari class "AccountPage"
class _AccountPageState extends State<AccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final UserController userController = Get.put(UserController());
  final AuthenticationController authController =
      Get.put(AuthenticationController());
  final _formKey = GlobalKey<FormState>();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    nameController.text = box.read('user')['name'];
    emailController.text = box.read('user')['email'];
  }

  void openDialogNotice(
    BuildContext context,
  ) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('close_account_question'.tr, style: textTheme.titleLarge!),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(deactiveNotice, style: textTheme.titleSmall!),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('no'.tr),
          ),
          TextButton(
            child: Text('ok'.tr),
            onPressed: () async {
              Navigator.of(context).pop();
              await authController.closeAccount();
            },
            // Navigator.of(context).pop()
          ),
        ],
      ),
    );
  }

  //   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // mengatur title page
//         title: const Center(
//           child: Text('Account'),
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // mengatur nama baru
//               Text(
//                 'Name',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   // bagian text box untuk mengisi nama baru
//                   hintText: "Name",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//                 validator: (value) {
//                   // validator untuk mengecek apakah nama telah diisi dan dengan jumlah karakter minimum
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   } else if (value.length < 3) {
//                     return 'Name must be at least 5 characters long';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               // mengatur email baru
//               Text(
//                 'Email',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   // bagian text box untuk mengisi email baru
//                   hintText: "Email",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//                 validator: (value) {
//                   // validator yang mengecek apakah email telah diisi dan dengan format yang benar
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an email address';
//                   } else if (!value.endsWith('@gmail.com')) {
//                     return 'Please enter your email address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       // bagian untuk menutup akun
//                       text: "Close Account",
//                       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                             color: Colors.red,
//                           ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           openDialogNotice(context);
//                         },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 // bagian untuk save data perubahan
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // menyimpan data setelah menekan tombol save
//                         if (_formKey.currentState!.validate()) {
//                           FocusScope.of(context).unfocus();
//                           await userController.changeUserData(
//                             email: emailController.text.trim(),
//                             name: nameController.text.trim(),
//                           );
//                         }
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Warna latar belakang
//                         foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Warna teks atau ikon
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                       ),
//                       child: Obx(() {
//                         // animasi loading
//                         return userController.isLoading.value
//                             ? const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               )
//                               // teks "Save"
//                             : const Text(
//                                 "Save",
//                                 style: TextStyle(fontWeight: FontWeight.bold), // Gaya teks
//                               );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // mengatur title page
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'account'.tr, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              // mengatur nama baru
              Text(
                'edit_profile_name'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  // bagian text box untuk mengisi nama baru
                  hintText: 'edit_profile_name'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  // validator untuk mengecek apakah nama telah diisi dan dengan jumlah karakter minimum
                  if (value == null || value.isEmpty) {
                    return 'name_required'.tr;
                  } else if (value.length < 3) {
                    return 'name_length_min'.tr;
                  } else if (value.length > 17) {
                    return 'name_length_max'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // mengatur email baru
              Text(
                'edit_profile_email'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  // bagian text box untuk mengisi email baru
                  hintText: 'edit_profile_email'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  // validator yang mengecek apakah email telah diisi dan dengan format yang benar
                  if (value == null || value.isEmpty) {
                    return 'email_null_check'.tr;
                  } else if (!value.endsWith('@gmail.com')) {
                    return 'email_format_required'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      // bagian untuk menutup akun
                      text: 'close_account'.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.red,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          openDialogNotice(context);
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                // bagian untuk save data perubahan
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // menyimpan data setelah menekan tombol save
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          await userController.changeUserData(
                            email: emailController.text.trim(),
                            name: nameController.text.trim(),
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
                      child: Obx(() {
                        // animasi loading
                        return userController.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            // teks "Save"
                            : Text(
                                'save'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold), // Gaya teks
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
    );
  }
}
