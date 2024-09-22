import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Fungsi validasi nomor kartu
  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your card number';
    } else if (value.length != 16) {
      return 'Card number must be 16 digits';
    }
    return null;
  }

  // Fungsi validasi tanggal kedaluwarsa
  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value)) {
      return 'Enter expiry date in MM/YY format';
    }
    return null;
  }

  // Fungsi validasi CVV
  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV';
    } else if (value.length != 3) {
      return 'CVV must be 3 digits';
    }
    return null;
  }

  // Fungsi untuk menyimpan dan mengirim data kartu
  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      // Data kartu yang akan dikirim ke server
      final cardData = {
        'card_number': cardNumberController.text,
        'expiry_date': expiryDateController.text,
        'cvv': cvvController.text,
      };

      try {
        // Mengirim data ke server menggunakan POST request
        final response = await http.post(
          Uri.parse('https://payment-service-sbx.pakar-digital.com'), // Ganti dengan URL API server Anda
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer SB-Mid-client-wYeSigdies_2dI1d', // Tambahkan token jika diperlukan
          },
          body: jsonEncode(cardData),
        );

        // Cek respon dari server
        if (response.statusCode == 200) {
          // Jika sukses
          Get.snackbar('Card Added', 'Your card has been added successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          // Jika gagal
          Get.snackbar('Error', 'Failed to add card. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } catch (e) {
        // Jika terjadi kesalahan saat mengirim request
        Get.snackbar('Error', 'An error occurred. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input nomor kartu
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'Enter your card number',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCardNumber,
              ),
              const SizedBox(height: 16),

              // Input tanggal kadaluwarsa (MM/YY)
              TextFormField(
                controller: expiryDateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                validator: _validateExpiryDate,
              ),
              const SizedBox(height: 16),

              // Input CVV
              TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: 'Enter CVV',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCVV,
              ),
              const SizedBox(height: 16),

              // Tombol untuk menyimpan kartu
              Center(
                child: ElevatedButton(
                  onPressed: _saveCard,
                  child: const Text('Add Card'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
