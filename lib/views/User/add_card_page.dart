import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Fungsi untuk menyimpan informasi kartu
  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      // Jika validasi sukses, tampilkan pesan sukses
      Get.snackbar('Card Added', 'Your card has been added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      // Anda bisa menambahkan logika untuk menyimpan kartu di sini
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
