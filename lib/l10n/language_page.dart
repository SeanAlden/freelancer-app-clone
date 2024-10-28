import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguagePage extends StatelessWidget {
  final getStorage = GetStorage();

  void changeLanguage(String languageCode, String countryCode) {
    var locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
    getStorage.write(
        'lang', '${languageCode}_$countryCode'); // Save the language choice
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'choose_language'.tr,
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ), // Translate title
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('English'),
            onTap: () => changeLanguage('en', 'US'),
          ),
          ListTile(
            title: Text('Indonesia'),
            onTap: () => changeLanguage('id', 'ID'),
          ),
          ListTile(
            title: Text('French'),
            onTap: () => changeLanguage('fr', 'FR'),
          ),
          ListTile(
            title: Text('Spanish'),
            onTap: () => changeLanguage('es', 'ES'),
          ),
          ListTile(
            title: Text('German'),
            onTap: () => changeLanguage('de', 'DE'),
          ),
          ListTile(
            title: Text('Italian'),
            onTap: () => changeLanguage('it', 'IT'),
          ),
          ListTile(
            title: Text('Portuguese'),
            onTap: () => changeLanguage('pt', 'PT'),
          ),
          ListTile(
            title: Text('Japanese'),
            onTap: () => changeLanguage('ja', 'JP'),
          ),
          ListTile(
            title: Text('Korean'),
            onTap: () => changeLanguage('ko', 'KR'),
          ),
          ListTile(
            title: Text('Arabic'),
            onTap: () => changeLanguage('ar', 'AE'),
          ),
          ListTile(
            title: Text('Russian'),
            onTap: () => changeLanguage('ru', 'RU'),
          ),
          ListTile(
            title: Text('Chinese'),
            onTap: () => changeLanguage('zh', 'CN'),
          ),
          ListTile(
            title: Text('Dutch'),
            onTap: () => changeLanguage('nl', 'NL'),
          ),
          ListTile(
            title: Text('Turkish'),
            onTap: () => changeLanguage('tr', 'TR'),
          ),
          ListTile(
            title: Text('Swedish'),
            onTap: () => changeLanguage('sv', 'SE'),
          ),
          ListTile(
            title: Text('Hindi'),
            onTap: () => changeLanguage('hi', 'IN'),
          ),
        ],
      ),
    );
  }
}
