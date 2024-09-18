import 'package:clone_freelancer_mobile/views/User/qris_page.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/globals.dart';
import 'package:clone_freelancer_mobile/views/Auth/login.dart';
// import 'package:clone_freelancer_mobile/views/User/category_page.dart';
import 'package:clone_freelancer_mobile/views/User/home_page.dart';
import 'package:clone_freelancer_mobile/views/User/orders_page.dart';
import 'package:clone_freelancer_mobile/views/User/profile_page.dart';
import 'package:clone_freelancer_mobile/views/chat/chat_page.dart';
import 'package:clone_freelancer_mobile/views/seller/Profile/seller_order_management.dart';
import 'package:clone_freelancer_mobile/views/seller/seller_home_page.dart';
import 'package:get/get.dart'; // Library GetX untuk state management dan navigasi
import 'package:get_storage/get_storage.dart'; // Library untuk penyimpanan data secara lokal

// Controller untuk mengontrol index tab yang dipilih pada BottomNavigationBar
class NavigationController extends GetxController {
  var selectedIndex = 0.obs; // Menggunakan .obs untuk reactive state management
}

// Widget utama untuk navigasi yang menggunakan BottomNavigationBar
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

// State untuk NavigationPage yang menangani tampilan BottomNavigationBar
class _NavigationPageState extends State<NavigationPage> {
  final box = GetStorage(); // Mengambil instance dari GetStorage untuk akses token
  ModeController modeController = Get.find<ModeController>(); // Mengambil instance ModeController (mengelola mode seller/user)
  NavigationController navigationController = Get.find<NavigationController>(); // Mengambil instance NavigationController

  // List widget yang akan ditampilkan berdasarkan index untuk user mode
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Halaman Home
    ChatPage(), // Halaman Chat (Inbox)
    // CategoryPage(), // Halaman Kategori
    QrisPage(), // Halaman Qris   
    ListOrderPage(), // Halaman Pesanan
    ProfilePage(), // Halaman Profil
  ];

  // List item untuk BottomNavigationBar pada user mode
  static const List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home', // Label untuk Home
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail_outline),
      label: 'Inbox', // Label untuk Inbox
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage(
            'assets/images/qris.png', // Menggunakan gambar khusus untuk QRIS
            ),
            size: 50, // Mengatur ukuran ikon
      ),
      label: 'QRIS', // Label untuk QRIS
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_outlined),
      label: 'Order', // Label untuk Pesanan
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile', // Label untuk Profil
    ),
  ];

  // List widget yang akan ditampilkan berdasarkan index untuk seller mode
  static const List<Widget> _widgetOptions1 = <Widget>[
    SellerHomePage(), // Halaman Home untuk seller
    ChatPage(), // Halaman Chat (Inbox)
    SellerOrderPage(), // Halaman Pesanan seller
    ProfilePage(), // Halaman Profil
  ];

  // List item untuk BottomNavigationBar pada seller mode
  static const List<BottomNavigationBarItem> bottomNavItems1 = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home', // Label untuk Home seller
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail_outline),
      label: 'Inbox', // Label untuk Inbox
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_outlined),
      label: 'Order', // Label untuk Pesanan seller
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile', // Label untuk Profil
    ),
  ];

  // Fungsi untuk meng-handle event ketika item pada BottomNavigationBar dipilih
  void _onItemTapped(int index) {
    // Jika pengguna belum login dan mencoba mengakses halaman tertentu, akan diarahkan ke halaman login
    if (box.read('token') == null &&
        !modeController.mode.value &&
        index % 2 != 0) {
      Get.to(() => const LoginPage()); // Navigasi ke halaman login
    } else {
      setState(() {
        navigationController.selectedIndex.value = index; // Mengubah index yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Obx untuk melakukan update UI ketika state berubah
    return Obx(() {
      return Scaffold(
        // Menampilkan widget berdasarkan index yang dipilih dan mode (user/seller)
        body: Center(
          child: !modeController.mode.value
              ? _widgetOptions.elementAt(navigationController.selectedIndex.value)
              : _widgetOptions1.elementAt(navigationController.selectedIndex.value),
        ),
        // BottomNavigationBar yang digunakan untuk navigasi
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Jenis BottomNavigationBar
          items: !modeController.mode.value ? bottomNavItems : bottomNavItems1, // Menyesuaikan item berdasarkan mode
          currentIndex: navigationController.selectedIndex.value, // Index tab yang dipilih
          selectedIconTheme: const IconThemeData(size: 28.0), // Mengatur ukuran ikon yang dipilih
          selectedFontSize: 16.0, // Ukuran font label yang dipilih
          unselectedFontSize: 12, // Ukuran font label yang tidak dipilih
          onTap: _onItemTapped, // Fungsi yang dipanggil saat item dipilih
          showSelectedLabels: false, // Sembunyikan label yang dipilih
          showUnselectedLabels: false, // Sembunyikan label yang tidak dipilih
        ),
      );
    });
  }
}
