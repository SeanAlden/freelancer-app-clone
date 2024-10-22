// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:clone_freelancer_mobile/core.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

// // class profil
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// // state untuk class "ProfilePage"
// class _ProfilePageState extends State<ProfilePage> {
//   final AuthenticationController authenticationController =
//       Get.put(AuthenticationController());
//   final UserController userController = Get.put(UserController());
//   ModeController modeController = Get.find<ModeController>();
//   NavigationController navigationController = Get.find<NavigationController>();
//   final box = GetStorage();
//   File? profileImage;

//   Future pickImageCamera() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.camera);
//       if (image == null) return;
//       File imageTemp = File(image.path);
//       setState(() {
//         profileImage = imageTemp;
//         userController.changeProfilePicture(profileImage!.path);
//       });
//     } on PlatformException catch (e) {
//       Get.snackbar(
//         "Error",
//         'Failed to pick image: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future pickImageGallery() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image == null) return;
//       File imageTemp = File(image.path);
//       setState(() {
//         profileImage = imageTemp;
//         userController.changeProfilePicture(profileImage!.path);
//       });
//     } on PlatformException catch (e) {
//       Get.snackbar(
//         "Error",
//         'Failed to pick image: $e',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future showOptions() async {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) => CupertinoActionSheet(
//         actions: [
//           CupertinoActionSheetAction(
//             child: const Text('Camera'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               pickImageCamera();
//             },
//           ),
//           CupertinoActionSheetAction(
//             child: const Text('Gallery'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               pickImageGallery();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future getReq() async {
//     try {
//       var response = await http.get(Uri.parse('${url}getRequest'), headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${box.read('token')}',
//       });
//       if (response.statusCode == 201) {
//         Get.to(() => const RequestSentPage());
//       } else {
//         Get.to(() => const SellerReqPage());
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future getUserType() async {
//     try {
//       var response = await http.get(Uri.parse('${url}getUserType'), headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer ${box.read('token')}',
//       });
//       if (response.statusCode == 201) {
//         var data = json.decode(response.body);
//         setState(() {
//           box.write('user', data['user']);
//         });
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     print('profile_type');
//     super.initState();
//     getUserType();
//   }

//   // Bagian widget untuk mengatur halaman profil
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title halaman profil
//         title: const Center(
//           child: Text(
//             "Profile",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             color: Colors.grey[100],
//             child: Column(
//               children: <Widget>[
//                 Stack(
//                   children: <Widget>[
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       margin: const EdgeInsets.only(bottom: 20.0),
//                       alignment: Alignment.topCenter,
//                       height: 235.0,
//                       decoration: const BoxDecoration(
//                         // Mengatur warna background profil di bagian atas
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.elliptical(30, 8),
//                           bottomRight: Radius.elliptical(30, 8),
//                         ),
//                         color:
//                         // Theme.of(context).brightness == Brightness.dark
//                         //     ? Color.fromARGB(255, 39, 39,
//                         //         70) // Warna background untuk mode gelap
//                         //     :
//                             const Color(
//                                 0xff4259E2), // Warna background untuk mode terang
//                       ),
//                       child: Column(
//                         children: [
//                           Stack(
//                             children: [
//                               profileImage != null
//                                   ? SizedBox(
//                                       // Mengatur tampilan gambar profil
//                                       width: 120,
//                                       height: 120,
//                                       child: ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: Image.file(
//                                           profileImage!,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     )
//                                   : box.read('pic') != null
//                                       ? SizedBox(
//                                           // Mengatur tampilan gambar profil yang berisi
//                                           width: 120,
//                                           height: 120,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             child: Image.network(
//                                               box.read('pic'),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         )
//                                       : SizedBox(
//                                           // Mengatur tampilan gambar profil blank
//                                           width: 120,
//                                           height: 120,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             child: Image.asset(
//                                               'assets/images/blank_image.png',
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                               Positioned(
//                                 // Bagian untuk mengatur tampilan option di sebelah profil untuk mengambil gambar profil, baik dari kamera maupun dari galeri
//                                 bottom: 0,
//                                 right: 0,
//                                 child: InkWell(
//                                   onTap: () {
//                                     if (box.read('token') == null) {
//                                       Get.to(() => const LoginPage());
//                                     } else {
//                                       showOptions();
//                                     }
//                                   },
//                                   child: Container(
//                                     width: 35,
//                                     height: 35,
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         color: const Color(0xff858AFF)),
//                                     child: const Icon(
//                                       Icons.camera_alt_outlined,
//                                       color: Colors.black,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 8,
//                           ),
//                           box.read('token') != null
//                               // Mengatur tampilan username dan email pengguna dibawah gambar profil
//                               ? Column(
//                                   children: [
//                                     Text(
//                                       // username
//                                       box.read('user')['name'],
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineSmall
//                                           ?.copyWith(color: Colors.white),
//                                     ),
//                                     Text(
//                                       // email
//                                       box.read('user')['email'],
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleLarge
//                                           ?.copyWith(color: Colors.white),
//                                     ),
//                                   ],
//                                 )
//                               : Text(
//                                   // Menampilkan "Guest" jika pengguna belum login
//                                   "Guest",
//                                   style:
//                                       Theme.of(context).textTheme.headlineSmall,
//                                 ),
//                         ],
//                       ),
//                     ),
//                     if (box.read('token') != null)
//                       // jika tipe user nya adalah freelancer, maka akan menampilkan toggle untuk memilih menjadi seller mode
//                       box.read('user')['profile_type'] == 'freelancer'
//                           ? Container(
//                               padding: const EdgeInsets.only(
//                                   top: 215, left: 16, right: 16),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   // Mengatur warna background toggle (putih)
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(32, 8, 32, 8),
//                                   child: Row(
//                                     // mengatur tulisan "Seller Mode"
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Seller Mode",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .titleMedium,
//                                       ),
//                                       Obx(() {
//                                         // Mengatur toggle
//                                         return Switch(
//                                           value: modeController.mode.value,
//                                           activeColor: const Color(0xff6571ff),
//                                           onChanged: (bool value) {
//                                             setState(() {
//                                               navigationController
//                                                   .selectedIndex.value = 0;
//                                               modeController.mode.value = value;
//                                             });
//                                           },
//                                         );
//                                       }),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                   ],
//                 ),
//                 if (modeController.mode.value == true)
//                   Column(
//                     children: [
//                       Container(
//                         // Bagian mengatur title "Selling" pada profil mode seller
//                         color: Colors.grey[100],
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Text(
//                               "Selling",
//                               style: Theme.of(context).textTheme.titleLarge,
//                             ),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         // Mengatur container bagian tombol "My Profile" ketika di klik, maka akan menuju ke "SellerProfilePage"
//                         onTap: () {
//                           print(box.read('pic'));
//                           Get.to(() => const SellerProfilePage())?.then(
//                             (_) {
//                               setState(() {});
//                             },
//                           );
//                         },
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             // Bagian mengatur warna container
//                             color: Colors.white,
//                             border: Border(
//                               bottom:
//                                   BorderSide(color: Colors.grey, width: 0.2),
//                               top: BorderSide(color: Colors.grey, width: 0.2),
//                             ),
//                           ),
//                           padding: const EdgeInsets.all(16),
//                           child: const Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 // Mengatur icon dan teks untuk tombol
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       right: 8,
//                                     ),
//                                     child: Icon(
//                                       Icons.person_outline,
//                                       size: 25,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   Text("My Profile"),
//                                 ],
//                               ),
//                               Icon(
//                                 // Mengatur icon untuk panah di bagian kanan
//                                 Icons.arrow_forward_ios_outlined,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Container(
//                       //   decoration: const BoxDecoration(
//                       //     color: Colors.white,
//                       //     border: Border(
//                       //       bottom: BorderSide(color: Colors.grey, width: 0.2),
//                       //     ),
//                       //   ),
//                       //   padding: const EdgeInsets.all(16),
//                       //   child: const Row(
//                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //     children: [
//                       //       Row(
//                       //         children: [
//                       //           Padding(
//                       //             padding: EdgeInsets.only(
//                       //               right: 8,
//                       //             ),
//                       //             child: Icon(
//                       //               Icons.book_outlined,
//                       //               size: 25,
//                       //               color: Colors.grey,
//                       //             ),
//                       //           ),
//                       //           Text("Manage Services"),
//                       //         ],
//                       //       ),
//                       //       Icon(
//                       //         Icons.arrow_forward_ios_outlined,
//                       //         size: 20,
//                       //         color: Colors.grey,
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                       // Container(
//                       //   decoration: const BoxDecoration(
//                       //     color: Colors.white,
//                       //     border: Border(
//                       //       bottom: BorderSide(color: Colors.grey, width: 0.2),
//                       //     ),
//                       //   ),
//                       //   padding: const EdgeInsets.all(16),
//                       //   child: const Row(
//                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //     children: [
//                       //       Row(
//                       //         children: [
//                       //           Padding(
//                       //             padding: EdgeInsets.only(
//                       //               right: 8,
//                       //             ),
//                       //             child: Icon(
//                       //               Icons.wallet_outlined,
//                       //               size: 25,
//                       //               color: Colors.grey,
//                       //             ),
//                       //           ),
//                       //           Text("Earnings"),
//                       //         ],
//                       //       ),
//                       //       Icon(
//                       //         Icons.arrow_forward_ios_outlined,
//                       //         size: 20,
//                       //         color: Colors.grey,
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 Column(
//                   children: [
//                     // kalau user belum sign up atau login
//                     if (box.read('token') == null)
//                       Column(
//                         children: [
//                           GestureDetector(
//                             // Ketika menekan tombol sign up, maka akan menuju SignUpPage
//                             onTap: () {
//                               Get.to(() => const SignUpPage());
//                             },
//                             child: Container(
//                               // Mengatur warna container pada tombol sign up
//                               decoration: const BoxDecoration(
//                                 color:
//                                 // Theme.of(context).brightness ==
//                                 //         Brightness.dark
//                                 //     ? Colors.grey:
//                                     Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: Row(
//                                 children: [
//                                   // Bagian untuk mengatur icon tombol sign up
//                                   const Padding(
//                                     padding: EdgeInsets.only(
//                                       right: 8,
//                                     ),
//                                     child: Icon(
//                                       Icons.add_circle_outline,
//                                       size: 25,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                   // Bagian untuk mengatur teks pada tombol
//                                   Text(
//                                     "Sign Up",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyLarge
//                                         ?.copyWith(
//                                           color: Colors.green,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             // Menuju ke Login Page
//                             onTap: () {
//                               Get.to(() => const LoginPage());
//                             },
//                             child: Container(
//                               // mengatur warna container dari tombol login
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               // bagian untuk mengatur icon dan teks dari tombol login
//                               padding: const EdgeInsets.all(16),
//                               child: const Row(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       right: 8,
//                                     ),
//                                     child: Icon(
//                                       Icons.login_outlined,
//                                       size: 25,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Log In",
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     // kalau user telah login
//                     if (box.read('token') != null)
//                       // mengatur bagian untuk settings
//                       Column(
//                         children: [
//                           Container(
//                             color: Colors.grey[100],
//                             child: Align(
//                               // membuat teks "Settings"
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Text(
//                                   "Settings",
//                                   style: Theme.of(context).textTheme.titleLarge,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Edit Profile
//                           GestureDetector(
//                             // Ketika tombol "Edit Profile" diklik, maka akan menuju ke halaman untuk edit profil
//                             onTap: () {
//                               Get.to(() => const AccountPage())?.then(
//                                 (_) {
//                                   setState(() {});
//                                 },
//                               );
//                             },
//                             child: Container(
//                               // mengatur warna container dari tombol edit profil
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                   top: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: const Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     // Mengatur icon dan teks tombol edit profil
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           right: 8,
//                                         ),
//                                         child: Icon(
//                                           Icons.manage_accounts_outlined,
//                                           size: 25,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Text("Edit Profile"),
//                                     ],
//                                   ),
//                                   Icon(
//                                     // icon panah di sebelah kanan
//                                     Icons.arrow_forward_ios_outlined,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Change Password
//                           GestureDetector(
//                             // ketika tombol di klik, maka akan menuju halaman "ChangePasswordPage"
//                             onTap: () {
//                               Get.to(() => const ChangePasswordPage());
//                             },
//                             child: Container(
//                               // Mengatur warna container dari tombol change password
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: const Row(
//                                 // mengatur icon dan teks untuk Change Password
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // mengatur icon dan teks nya
//                                   Row(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           right: 8,
//                                         ),
//                                         child: Icon(
//                                           Icons.password_outlined,
//                                           size: 25,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Text("Change Password"),
//                                     ],
//                                   ),
//                                   // icon panah di sebelah kanan
//                                   Icon(
//                                     Icons.arrow_forward_ios_outlined,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // kalau masih sebagai client, tampilkan tombol "Become a Seller"
//                           box.read('user')['profile_type'] == 'client'
//                               ? GestureDetector(
//                                   onTap: () {
//                                     getReq();
//                                   },
//                                   child: Container(
//                                     // Mengatur warna untuk container
//                                     decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       border: Border(
//                                         bottom: BorderSide(
//                                             color: Colors.grey, width: 0.2),
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.all(16),
//                                     child: const Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           // mengatur icon dan teks untuk tombol ini
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                 right: 8,
//                                               ),
//                                               child: Icon(
//                                                 Icons.store_outlined,
//                                                 size: 25,
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                             Text("Become a Seller"),
//                                           ],
//                                         ),
//                                         Icon(
//                                           // icon panah di sebelah kanan
//                                           Icons.arrow_forward_ios_outlined,
//                                           size: 20,
//                                           color: Colors.grey,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               : Container(),
//                           // Wallet
//                           GestureDetector(
//                             // menuju ke halaman "Wallet"
//                             onTap: () {
//                               Get.to(() => const WalletPage());
//                             },
//                             child: Container(
//                               // mengatur warna container
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: const Row(
//                                 // mengatur icon dan teks untuk tombol wallet
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     // icon dan teks tombol
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           right: 8,
//                                         ),
//                                         child: Icon(
//                                           Icons.account_balance_wallet_outlined,
//                                           size: 25,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Text("Wallet"),
//                                     ],
//                                   ),
//                                   Icon(
//                                     // icon panah pada bagian kanan
//                                     Icons.arrow_forward_ios_outlined,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Saved Service
//                           GestureDetector(
//                             // menuju ke halaman "SavedServicePage"
//                             onTap: () {
//                               Get.to(() => const SavedServicesPage());
//                             },
//                             child: Container(
//                               // mengatur warna container untuk tombol "Saved Service"
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: const Row(
//                                 // bagian untuk mengatur icon dan teks pada tombol saved service
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // mengatur icon dan teks
//                                   Row(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           right: 8,
//                                         ),
//                                         child: Icon(
//                                           Icons.archive_outlined,
//                                           size: 25,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Text("Saved Service"),
//                                     ],
//                                   ),
//                                   Icon(
//                                     // icon panah di bagian kanan
//                                     Icons.arrow_forward_ios_outlined,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Support
//                           GestureDetector(
//                             onTap: () {
//                               // Menuju ke halaman "Support"
//                               Get.to(() => const SupportListPage());
//                             },
//                             child: Container(
//                               // mengatur container untuk tombol support
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.2),
//                                 ),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: const Row(
//                                 // mengatur icon dan teks pada tombol support
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // icon dan teks tombol support
//                                   Row(
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           right: 8,
//                                         ),
//                                         child: Icon(
//                                           Icons.support,
//                                           size: 25,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       Text("Support"),
//                                     ],
//                                   ),
//                                   Icon(
//                                     // icon panah di bagian kanan
//                                     Icons.arrow_forward_ios_outlined,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     // kalau ada user, maka menampilkan tombol logout
//                     if (box.read('token') != null)
//                       GestureDetector(
//                         // ketika menekan tombol ini, maka akan mengeluarkan user dan mengarahkan ke home mode guest
//                         onTap: () async {
//                           await authenticationController.logout();
//                           setState(() {
//                             navigationController.selectedIndex.value = 0;
//                             modeController.mode.value = false;
//                           });
//                         },
//                         child: Container(
//                           // mengatur container dari tombol logout
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             border: Border(
//                               bottom:
//                                   BorderSide(color: Colors.grey, width: 0.2),
//                             ),
//                           ),
//                           padding: const EdgeInsets.all(16),
//                           child: const Row(
//                             // mengatur icon dan teks untuk tombol logour
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   right: 8,
//                                 ),
//                                 child: Icon(
//                                   Icons.logout_outlined,
//                                   size: 25,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               Text(
//                                 "Log Out",
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 // space ruang bagian bawah
//                 const SizedBox(
//                   height: 32,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// class profil
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// state untuk class "ProfilePage"
class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final UserController userController = Get.put(UserController());
  ModeController modeController = Get.find<ModeController>();
  NavigationController navigationController = Get.find<NavigationController>();
  final box = GetStorage();
  File? profileImage;

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      File imageTemp = File(image.path);
      setState(() {
        profileImage = imageTemp;
        userController.changeProfilePicture(profileImage!.path);
      });
    } on PlatformException catch (e) {
      Get.snackbar(
        "Error",
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File imageTemp = File(image.path);
      setState(() {
        profileImage = imageTemp;
        userController.changeProfilePicture(profileImage!.path);
      });
    } on PlatformException catch (e) {
      Get.snackbar(
        "Error",
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              pickImageCamera();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              pickImageGallery();
            },
          ),
        ],
      ),
    );
  }

  Future getReq() async {
    try {
      var response = await http.get(Uri.parse('${url}getRequest'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 201) {
        Get.to(() => const RequestSentPage());
      } else {
        Get.to(() => const SellerReqPage());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getUserType() async {
    try {
      var response = await http.get(Uri.parse('${url}getUserType'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        setState(() {
          box.write('user', data['user']);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    print('profile_type');
    super.initState();
    getUserType();
  }

  // Bagian widget untuk mengatur halaman profil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title halaman profil
        title: const Center(
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Container untuk mengatur scroll view pada halaman profil
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900] // Warna untuk mode gelap
                : Colors.grey[100], // Warna untuk mode terang
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      alignment: Alignment.topCenter,
                      height: 235.0,
                      // decoration: const BoxDecoration(
                      //   // Mengatur warna background profil di bagian atas
                      //   borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.elliptical(30, 8),
                      //     bottomRight: Radius.elliptical(30, 8),
                      //   ),
                      //   color: Color(0xff4259E2),
                      // ),
                      decoration: BoxDecoration(
                        // Mengatur warna background profil di bagian atas
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.elliptical(30, 8),
                          bottomRight: Radius.elliptical(30, 8),
                        ),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromARGB(255, 48, 48,
                                85) // Warna background untuk mode gelap
                            : const Color(
                                0xff4259E2), // Warna background untuk mode terang
                      ),

                      child: Column(
                        children: [
                          Stack(
                            children: [
                              profileImage != null
                                  ? SizedBox(
                                      // Mengatur tampilan gambar profil
                                      width: 120,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          profileImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : box.read('pic') != null
                                      ? SizedBox(
                                          // Mengatur tampilan gambar profil yang berisi
                                          width: 120,
                                          height: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              box.read('pic'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          // Mengatur tampilan gambar profil blank
                                          width: 120,
                                          height: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                              'assets/images/blank_image.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                              Positioned(
                                // Bagian untuk mengatur tampilan option di sebelah profil untuk mengambil gambar profil, baik dari kamera maupun dari galeri
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    if (box.read('token') == null) {
                                      Get.to(() => const LoginPage());
                                    } else {
                                      showOptions();
                                    }
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color(0xff858AFF)),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          box.read('token') != null
                              // Mengatur tampilan username dan email pengguna dibawah gambar profil
                              ? Column(
                                  children: [
                                    Text(
                                      // username
                                      box.read('user')['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors
                                                    .white // Warna teks untuk mode gelap
                                                : Colors
                                                    .white, // Warna teks untuk mode terang
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                    ),
                                    Text(
                                      // email
                                      box.read('user')['email'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors
                                                    .white // Warna teks untuk mode gelap
                                                : Colors
                                                    .white, // Warna teks untuk mode terang
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                    ),
                                  ],
                                )
                              // : Text(
                              //     // Menampilkan "Guest" jika pengguna belum login
                              //     "Guest",
                              //     style:
                              //         Theme.of(context).textTheme.headlineSmall,
                              //   ),
                              : Text(
                                  // Menampilkan "Guest" jika pengguna belum login
                                  "Guest",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors
                                                .white // Warna teks untuk mode gelap
                                            : Colors
                                                .white, // Warna teks untuk mode terang
                                      ),
                                ),
                        ],
                      ),
                    ),
                    if (box.read('token') != null)
                      // jika tipe user nya adalah freelancer, maka akan menampilkan toggle untuk memilih menjadi seller mode
                      box.read('user')['profile_type'] == 'freelancer'
                          ? Container(
                              padding: const EdgeInsets.only(
                                  top: 215, left: 16, right: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  // Mengatur warna background toggle (putih)
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Color.fromARGB(255, 61, 61, 61)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(32, 8, 32, 8),
                                  child: Row(
                                    // mengatur tulisan "Seller Mode"
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Seller Mode",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Obx(() {
                                        // Mengatur toggle
                                        return Switch(
                                          value: modeController.mode.value,
                                          activeColor: const Color(0xff6571ff),
                                          onChanged: (bool value) {
                                            setState(() {
                                              navigationController
                                                  .selectedIndex.value = 0;
                                              modeController.mode.value = value;
                                            });
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                  ],
                ),
                if (modeController.mode.value == true)
                  Column(
                    children: [
                      Container(
                        // Bagian Container untuk mengatur title "Selling" pada profil mode seller
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900] // Warna untuk mode gelap
                            : Colors.grey[100], // Warna untuk mode terang
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Selling",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        // Mengatur container bagian tombol "My Profile" ketika di klik, maka akan menuju ke "SellerProfilePage"
                        onTap: () {
                          print(box.read('pic'));
                          Get.to(() => const SellerProfilePage())?.then(
                            (_) {
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // Bagian mengatur warna container
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.black // Warna untuk mode gelap
                                : Colors.white, // Warna untuk mode terang
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.2),
                              top: BorderSide(color: Colors.grey, width: 0.2),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                // Mengatur icon dan teks untuk tombol
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text("My Profile"),
                                ],
                              ),
                              Icon(
                                // Mengatur icon untuk panah di bagian kanan
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border(
                      //       bottom: BorderSide(color: Colors.grey, width: 0.2),
                      //     ),
                      //   ),
                      //   padding: const EdgeInsets.all(16),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.only(
                      //               right: 8,
                      //             ),
                      //             child: Icon(
                      //               Icons.book_outlined,
                      //               size: 25,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //           Text("Manage Services"),
                      //         ],
                      //       ),
                      //       Icon(
                      //         Icons.arrow_forward_ios_outlined,
                      //         size: 20,
                      //         color: Colors.grey,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border(
                      //       bottom: BorderSide(color: Colors.grey, width: 0.2),
                      //     ),
                      //   ),
                      //   padding: const EdgeInsets.all(16),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.only(
                      //               right: 8,
                      //             ),
                      //             child: Icon(
                      //               Icons.wallet_outlined,
                      //               size: 25,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //           Text("Earnings"),
                      //         ],
                      //       ),
                      //       Icon(
                      //         Icons.arrow_forward_ios_outlined,
                      //         size: 20,
                      //         color: Colors.grey,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                Column(
                  children: [
                    // kalau user belum sign up atau login
                    if (box.read('token') == null)
                      Column(
                        children: [
                          GestureDetector(
                            // Ketika menekan tombol sign up, maka akan menuju SignUpPage
                            onTap: () {
                              Get.to(() => const SignUpPage());
                            },
                            child: Container(
                              // Mengatur warna container pada tombol sign up
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Bagian untuk mengatur icon tombol sign up
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      size: 25,
                                      color: Colors.green,
                                    ),
                                  ),
                                  // Bagian untuk mengatur teks pada tombol
                                  Text(
                                    "Sign Up",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.green,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            // Menuju ke Login Page
                            onTap: () {
                              Get.to(() => const LoginPage());
                            },
                            child: Container(
                              // mengatur warna container dari tombol login
                              // decoration: const BoxDecoration(
                              //   color: Colors.white,
                              //   border: Border(
                              //     bottom: BorderSide(
                              //         color: Colors.grey, width: 0.2),
                              //   ),
                              // ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              // bagian untuk mengatur icon dan teks dari tombol login
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Icon(
                                      Icons.login_outlined,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Log In",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    // kalau user telah login
                    if (box.read('token') != null)
                      // mengatur bagian untuk settings
                      Column(
                        children: [
                          // Container untuk tulisan Settings
                          Container(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors
                                    .grey[900] // Warna teks untuk mode gelap
                                : Colors
                                    .grey[100], // Warna teks untuk mode terang
                            child: Align(
                              // membuat teks "Settings"
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Settings",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                          // Edit Profile
                          GestureDetector(
                            // Ketika tombol "Edit Profile" diklik, maka akan menuju ke halaman untuk edit profil
                            onTap: () {
                              Get.to(() => const AccountPage())?.then(
                                (_) {
                                  setState(() {});
                                },
                              );
                            },
                            child: Container(
                              // mengatur warna container dari tombol edit profil
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors
                                        .black // Warna teks untuk mode gelap
                                    : Colors
                                        .white, // Warna teks untuk mode terang
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    // Mengatur icon dan teks tombol edit profil
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.manage_accounts_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Edit Profile"),
                                    ],
                                  ),
                                  Icon(
                                    // icon panah di sebelah kanan
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Change Password
                          GestureDetector(
                            // ketika tombol di klik, maka akan menuju halaman "ChangePasswordPage"
                            onTap: () {
                              Get.to(() => const ChangePasswordPage());
                            },
                            child: Container(
                              // Mengatur warna container dari tombol change password
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors
                                        .black // Warna teks untuk mode gelap
                                    : Colors
                                        .white, // Warna teks untuk mode terang
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                // mengatur icon dan teks untuk Change Password
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // mengatur icon dan teks nya
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.password_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Change Password"),
                                    ],
                                  ),
                                  // icon panah di sebelah kanan
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // kalau masih sebagai client, tampilkan tombol "Become a Seller"
                          box.read('user')['profile_type'] == 'client'
                              ? GestureDetector(
                                  onTap: () {
                                    getReq();
                                  },
                                  child: Container(
                                    // Mengatur warna untuk container
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors
                                              .black // Warna teks untuk mode gelap
                                          : Colors
                                              .white, // Warna teks untuk mode terang
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.2),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          // mengatur icon dan teks untuk tombol ini
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Icon(
                                                Icons.store_outlined,
                                                size: 25,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text("Become a Seller"),
                                          ],
                                        ),
                                        Icon(
                                          // icon panah di sebelah kanan
                                          Icons.arrow_forward_ios_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          // Wallet
                          GestureDetector(
                            // menuju ke halaman "Wallet"
                            onTap: () {
                              Get.to(() => const WalletPage());
                            },
                            child: Container(
                              // mengatur warna background wallet
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors
                                        .black // Warna teks untuk mode gelap
                                    : Colors
                                        .white, // Warna teks untuk mode terang
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                // mengatur icon dan teks untuk tombol wallet
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    // icon dan teks tombol
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.account_balance_wallet_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Wallet"),
                                    ],
                                  ),
                                  Icon(
                                    // icon panah pada bagian kanan
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Saved Service
                          GestureDetector(
                            // menuju ke halaman "SavedServicePage"
                            onTap: () {
                              Get.to(() => const SavedServicesPage());
                            },
                            child: Container(
                              // mengatur warna container untuk tombol "Saved Service"
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors
                                        .black // Warna teks untuk mode gelap
                                    : Colors
                                        .white, // Warna teks untuk mode terang
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                // bagian untuk mengatur icon dan teks pada tombol saved service
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // mengatur icon dan teks
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.archive_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Saved Service"),
                                    ],
                                  ),
                                  Icon(
                                    // icon panah di bagian kanan
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Support
                          GestureDetector(
                            onTap: () {
                              // Menuju ke halaman "Support"
                              Get.to(() => const SupportListPage());
                            },
                            child: Container(
                              // mengatur container untuk tombol support
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors
                                        .black // Warna teks untuk mode gelap
                                    : Colors
                                        .white, // Warna teks untuk mode terang
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                // mengatur icon dan teks pada tombol support
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // icon dan teks tombol support
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.support,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Support"),
                                    ],
                                  ),
                                  Icon(
                                    // icon panah di bagian kanan
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    // kalau ada user, maka menampilkan tombol logout
                    if (box.read('token') != null)
                      GestureDetector(
                        // ketika menekan tombol ini, maka akan mengeluarkan user dan mengarahkan ke home mode guest
                        onTap: () async {
                          await authenticationController.logout();
                          setState(() {
                            navigationController.selectedIndex.value = 0;
                            modeController.mode.value = false;
                          });
                        },
                        child: Container(
                          // mengatur container dari tombol logout
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.black // Warna teks untuk mode gelap
                                : Colors.white, // Warna teks untuk mode terang
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.2),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            // mengatur icon dan teks untuk tombol logour
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 8,
                                ),
                                child: Icon(
                                  Icons.logout_outlined,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // space ruang bagian bawah
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
