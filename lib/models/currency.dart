import 'package:intl/intl.dart'; // Mengimpor library intl untuk format tanggal dan angka, termasuk format mata uang.

class CurrencyFormat {
  // Metode statis untuk mengkonversi angka menjadi format mata uang IDR.
  static String convertToIdr(dynamic number, int decimalDigit) {
    
    // Membuat objek NumberFormat dengan format mata uang Indonesia (IDR).
    // Parameter 'locale' menentukan lokal atau negara, dalam hal ini 'id' untuk Indonesia.
    // Parameter 'symbol' menentukan simbol mata uang, dalam hal ini 'Rp ' untuk Rupiah.
    // Parameter 'decimalDigits' menentukan jumlah digit desimal setelah koma.
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    
    // Mengembalikan angka yang sudah diformat menjadi string dalam format mata uang IDR.
    return currencyFormatter.format(number);
  }
}
