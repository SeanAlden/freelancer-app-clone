// import 'package:flutter/material.dart';
// import 'package:clone_freelancer_mobile/constant/globals.dart';
// import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';

// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

// // Fungsi utama aplikasi
// void main() async {
//   // Inisialisasi GetStorage untuk manajemen penyimpanan data lokal
//   await GetStorage.init();

//   // Inisialisasi platform Google Maps Flutter
//   final GoogleMapsFlutterPlatform mapsImplementation =
//       GoogleMapsFlutterPlatform.instance;
//   if (mapsImplementation is GoogleMapsFlutterAndroid) {
//     // Force Hybrid Composition mode. Menggunakan komposisi hybrid pada platform Android
//     mapsImplementation.useAndroidViewSurface = true;
//   }
//   // Memulai aplikasi dengan menjalankan widget MyApp
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     // Menggunakan GetMaterialApp dari package GetX untuk state management dan navigasi
//     return GetMaterialApp(
//       // Menentukan tema aplikasi (light mode)
//       theme: ThemeData(
//           brightness: Brightness.light, // mengatur tema menjadi light mode
//           textTheme: GoogleFonts
//               .poppinsTextTheme(), // menggunakan font 'poppins' untuk text theme
//           scaffoldBackgroundColor: Colors.white, // warna background page
//           appBarTheme: const AppBarTheme(
//             color:
//                 Color.fromARGB(255, 93, 82, 255), // warna default untuk AppBar
//           )),
//       debugShowCheckedModeBanner:
//           false, // menyembunyikan banner pada kanan atas
//       title: 'Freelancer-App', // judul aplikasi
//       home: const NavigationPage(), // halaman awal aplikasi
//       initialBinding: BindingsBuilder(() {
//         // inisialisasi controller yang akan digunakan untuk GetX
//         Get.put(
//             ModeController()); // mengatur mode controller (untuk mengelola mode aplikasi, misalnya dark/light mode)
//         Get.put(
//             NavigationController()); // mengatur navigation controller (untuk mengelola navigasi di aplikasi)
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/globals.dart';
import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

// Fungsi utama aplikasi
void main() async {
  // Inisialisasi GetStorage untuk manajemen penyimpanan data lokal
  await GetStorage.init();

  // Inisialisasi platform Google Maps Flutter
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // Force Hybrid Composition mode. Menggunakan komposisi hybrid pada platform Android
    mapsImplementation.useAndroidViewSurface = true;
  }
  // Memulai aplikasi dengan menjalankan widget MyApp
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan mode sistem (light/dark)
    final brightness = MediaQuery.of(context).platformBrightness;

    // Menggunakan GetMaterialApp dari package GetX untuk state management dan navigasi
    return GetMaterialApp(
      // Menentukan mode tema berdasarkan tema sistem
      themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      
      // Menentukan tema light mode
      theme: ThemeData(
          brightness: Brightness.light, // mengatur tema menjadi light mode
          textTheme: GoogleFonts.poppinsTextTheme(), // menggunakan font 'poppins' untuk text theme
          scaffoldBackgroundColor: Colors.white, // warna background page
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 93, 82, 255), // warna default untuk AppBar
          )),

      // Menentukan tema dark mode
      darkTheme: ThemeData(
          brightness: Brightness.dark, // mengatur tema menjadi dark mode
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme, // menyesuaikan text theme dengan mode dark
          ),
          scaffoldBackgroundColor: Colors.black, // warna background page untuk dark mode
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 33, 33, 33), // warna AppBar untuk dark mode
          )),
      
      debugShowCheckedModeBanner: false, // menyembunyikan banner pada kanan atas
      title: 'Freelancer-App', // judul aplikasi
      home: const NavigationPage(), // halaman awal aplikasi
      initialBinding: BindingsBuilder(() {
        // inisialisasi controller yang akan digunakan untuk GetX
        Get.put(ModeController()); // mengatur mode controller (untuk mengelola mode aplikasi, misalnya dark/light mode)
        Get.put(NavigationController()); // mengatur navigation controller (untuk mengelola navigasi di aplikasi)
      }),
    );
  }
}

