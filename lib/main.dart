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

// import 'package:flutter/material.dart';
// import 'package:clone_freelancer_mobile/constant/globals.dart';
// import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';

// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

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
//   // runApp(const MyApp());
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   // static void setLocale(BuildContext context, Locale newLocale) {
//   //   _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
//   //   state.setLocale(newLocale);
//   // }

//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // Locale _locale = Locale('intl_en'); // Default language is English

//   // void setLocale(Locale locale) {
//   //   setState(() {
//   //     _locale = locale;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // Mendapatkan mode sistem (light/dark)
//     final brightness = MediaQuery.of(context).platformBrightness;

//     // Menggunakan GetMaterialApp dari package GetX untuk state management dan navigasi
//     return GetMaterialApp(
//       // locale: _locale, // Default language
//       // localizationsDelegates: [
//       //   GlobalMaterialLocalizations.delegate,
//       //   GlobalWidgetsLocalizations.delegate,
//       //   GlobalCupertinoLocalizations.delegate,
//       // ],
//       // supportedLocales: [
//       //   Locale('intl_en', ''), // English
//       //   Locale('intl_id', ''), // Bahasa Indonesia
//       //   Locale('intl_fr', ''), // French (Prancis)
//       //   Locale('intl_es', ''), // Spanish (Spanyol)
//       //   Locale('intl_de', ''), // German (Jerman)
//       // ],

//       // Menentukan mode tema berdasarkan tema sistem
//       themeMode:
//           brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,

//       // Menentukan tema light mode
//       theme: ThemeData(
//           brightness: Brightness.light, // mengatur tema menjadi light mode
//           textTheme: GoogleFonts
//               .poppinsTextTheme(), // menggunakan font 'poppins' untuk text theme
//           scaffoldBackgroundColor: Colors.white, // warna background page
//           appBarTheme: const AppBarTheme(
//             color:
//                 Color.fromARGB(255, 93, 82, 255), // warna default untuk AppBar
//           )),

//       // Menentukan tema dark mode
//       darkTheme: ThemeData(
//           brightness: Brightness.dark, // mengatur tema menjadi dark mode
//           textTheme: GoogleFonts.poppinsTextTheme(
//             ThemeData(brightness: Brightness.dark)
//                 .textTheme, // menyesuaikan text theme dengan mode dark
//           ),
//           scaffoldBackgroundColor:
//               Colors.black, // warna background page untuk dark mode
//           appBarTheme: const AppBarTheme(
//             color:
//                 Color.fromARGB(255, 33, 33, 33), // warna AppBar untuk dark mode
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
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/translations.dart'; // Import file translations
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await GetStorage.init();

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final getStorage = GetStorage(); // Initialize GetStorage for local storage
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    String localeLang = getStorage.read('lang') ?? 'en_US'; // Default language

    return GetMaterialApp(
      translations: AppTranslations(), // Menambahkan translasi
      // locale: Locale('en', 'US'), // Locale default bahasa Inggris
      locale: Locale(localeLang.split('_')[0], localeLang.split('_')[1]),
      fallbackLocale: Locale('en', 'US'), // Fallback jika bahasa tidak tersedia
      supportedLocales: const [
        Locale('en', 'US'), // Inggris
        Locale('id', 'ID'), // Indonesia
        Locale('fr', 'FR'), // Prancis
        Locale('es', 'ES'), // Spanyol
        Locale('de', 'DE'), // Jerman
        Locale('it', 'IT'), // Italia
        Locale('pt', 'PT'), // Portugis
        Locale('ja', 'JP'), // Jepang
        Locale('ko', 'KR'), // Korea
        Locale('ar', 'AE'), // Arab
        Locale('ru', 'RU'), // Rusia
        Locale('zh', 'CN'), // Tiongkok
        Locale('nl', 'NL'), // Belanda
        Locale('tr', 'TR'), // Turki
        Locale('sv', 'SE'), // Swedia
        Locale('hi', 'IN'), // India
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode:
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 93, 82, 255),
          )),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 33, 33, 33),
          )),
      debugShowCheckedModeBanner: false,
      title: 'Freelancer-App',
      home: const NavigationPage(),
      initialBinding: BindingsBuilder(() {
        Get.put(ModeController());
        Get.put(NavigationController());
      }),
    );
  }
}
