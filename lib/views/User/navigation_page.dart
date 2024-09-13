import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/globals.dart';
import 'package:clone_freelancer_mobile/views/Auth/login.dart';
import 'package:clone_freelancer_mobile/views/User/category_page.dart';
import 'package:clone_freelancer_mobile/views/User/home_page.dart';
import 'package:clone_freelancer_mobile/views/User/orders_page.dart';
import 'package:clone_freelancer_mobile/views/User/profile_page.dart';
import 'package:clone_freelancer_mobile/views/chat/chat_page.dart';
import 'package:clone_freelancer_mobile/views/seller/Profile/seller_order_management.dart';
import 'package:clone_freelancer_mobile/views/seller/seller_home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final box = GetStorage();
  ModeController modeController = Get.find<ModeController>();
  NavigationController navigationController = Get.find<NavigationController>();

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChatPage(),
    CategoryPage(),
    ListOrderPage(),
    ProfilePage(),
  ];

  static const List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail_outline),
      label: 'Inbox',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.search),
    //   label: 'Favorite',
    // ),
    // mengganti search icon pada bagian bawah dengan icon QRIS
    BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage(
            'assets/images/qris.png',
            ),
            size: 50, // Ganti dengan path file gambar Anda
      ),
      label: 'QRIS',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_outlined),
      label: 'Order',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
    ),
  ];

  static const List<Widget> _widgetOptions1 = <Widget>[
    SellerHomePage(),
    ChatPage(),
    SellerOrderPage(),
    ProfilePage(),
  ];

  static const List<BottomNavigationBarItem> bottomNavItems1 = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail_outline),
      label: 'Inbox',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt_outlined),
      label: 'Order',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    if (box.read('token') == null &&
        !modeController.mode.value &&
        index % 2 != 0) {
      Get.to(() => const LoginPage());
    } else {
      setState(() {
        navigationController.selectedIndex.value = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Center(
          child: !modeController.mode.value
              ? _widgetOptions
                  .elementAt(navigationController.selectedIndex.value)
              : _widgetOptions1
                  .elementAt(navigationController.selectedIndex.value),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: !modeController.mode.value ? bottomNavItems : bottomNavItems1,
          currentIndex: navigationController.selectedIndex.value,
          selectedIconTheme: const IconThemeData(size: 28.0),
          selectedFontSize: 16.0,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      );
    });
  }
}
