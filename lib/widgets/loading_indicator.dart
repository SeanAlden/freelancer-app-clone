import 'package:flutter/material.dart';

// Deklarasi kelas LoaderTransparent yang merupakan subclass dari StatelessWidget
class LoaderTransparent extends StatelessWidget {
  // Properti height dan width untuk menentukan tinggi dan lebar widget
  final double height;
  final double width;

// Constructor untuk widget LoaderTransparent dengan parameter height dan width yang diperlukan
  const LoaderTransparent({Key? key, required this.height, required this.width})
      : super(key: key);

  // Method build untuk menentukan tampilan widget
  @override
  Widget build(BuildContext context) {
    // Container dengan tinggi dan lebar sesuai parameter
    return Container(
      height: height,
      width: width,
      // Warna abu-abu dengan transparansi 50%
      color: Colors.grey.withOpacity(0.5),
      // Center widget untuk menempatkan CircularProgressIndicator di tengah container
      child: const Center(
        // SizedBox untuk menentukan ukuran loader (60x60)
        child: SizedBox(
          height: 60.0, // Tinggi loader 60 piksel
          width: 60.0, // Lebar loader 60 piksel
          // CircularProgressIndicator sebagai indikator pemuatan berbentuk lingkaran
          child: CircularProgressIndicator(
            // Menetapkan warna biru untuk indikator pemuatan
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)
            ,
            // Ketebalan garis indikator pemuatan (5 piksel)
            strokeWidth: 5.0,
          ),
        ),
      ),
    );
  }
}
