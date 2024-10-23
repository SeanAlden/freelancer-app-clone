// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart'; // Untuk navigasi dan state management

// class QrPage extends StatefulWidget {
//   const QrPage({super.key});

//   @override
//   _QrPageState createState() => _QrPageState();
// }

// class _QrPageState extends State<QrPage> {
//   String? qrCodeUrl; // URL untuk QR Code
//   bool isLoading = false; // Untuk menunjukkan progress loading
//   final String serverKey =
//       // 'SB-Mid-server-oMwzHTehVPNXAR92-ba_cE_J'; // Ganti dengan server key Midtrans
//       'SB-Mid-client-wYeSigdies_2dI1d'; // Ganti dengan server key Midtrans
//   final String apiUrl = 'https://payment-service-sbx.pakar-digital.com'; // Sandbox API URL

//   // Fungsi untuk memproses transaksi dan mendapatkan QR Code
//   Future<void> createQrisTransaction() async {
//     setState(() {
//       isLoading = true;
//     });

//     // Data yang dikirim ke Midtrans API
//     var transactionData = {
//       "payment_type": "qris",
//       "transaction_details": {
//         "order_id": "order-${DateTime.now().millisecondsSinceEpoch}",
//         "gross_amount": 20000 // Jumlah transaksi
//       },
//       "customer_details": {
//         "first_name": "John",
//         "last_name": "Doe",
//         "email": "johndoe@example.com",
//         "phone": "081234567890"
//       }
//     };

//     var response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Basic ' + base64Encode(utf8.encode(serverKey)),
//         'Content-Type': 'application/json',
//         'Accept': 'application/json'
//       },
//       body: jsonEncode(transactionData),
//     );

//     if (response.statusCode == 201) {
//       var responseData = jsonDecode(response.body);
//       setState(() {
//         qrCodeUrl =
//             responseData['actions'][0]['url']; // Mendapatkan URL QR Code
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       Get.snackbar('Error', 'Failed to create QRIS transaction');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     createQrisTransaction(); // Buat transaksi saat halaman dibuka
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QRIS Payment'),
//       ),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator() // Menampilkan loading indicator saat transaksi dibuat
//             : qrCodeUrl != null
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.network(qrCodeUrl!), // Menampilkan QR Code
//                       SizedBox(height: 20),
//                       Text(
//                         'Scan QR Code untuk melakukan pembayaran',
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   )
//                 : Text('Gagal memuat QR Code, coba lagi'),
//       ),
//     );
//   }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class QrPage extends StatefulWidget {
//   const QrPage ({super.key});

//   @override
//   _QrPageState createState() => _QrPageState();
// }

// class _QrPageState extends State<QrPage> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;

//   // Fungsi untuk membuka galeri dan memilih gambar
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QRIS Supported'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Bagian kamera atau placeholder untuk kamera
//           Expanded(
//             child: Container(
//               color: Colors.grey[200],
//               child: Center(
//                 child: _imageFile == null
//                     ? Icon(Icons.camera_alt, size: 100, color: Colors.grey)
//                     : Image.file(File(_imageFile!.path)),
//               ),
//             ),
//           ),
//           // Fitur Upload QR dan Input Tiket
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _pickImage,
//                   icon: Icon(Icons.upload_file),
//                   label: Text("Upload QR"),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Tambahkan logika untuk Input Tiket
//                   },
//                   icon: Icon(Icons.confirmation_number),
//                   label: Text("Input Tiket"),
//                 ),
//               ],
//             ),
//           ),
//           // Teks "Bisa juga bayar pakai"
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Bisa juga bayar pakai",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           // Bagian metode pembayaran lainnya (Alfamart, Indomaret, Loyalty Code)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildPaymentOption('Alfamart', 'Kode QRIS'),
//                 _buildPaymentOption('Indomaret', 'Kode Bayar'),
//               ],
//             ),
//           ),
//           // Loyalty Code
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildLoyaltyCodeOption('Loyalty Code'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Fungsi untuk membuat tombol pilihan pembayaran
//   Widget _buildPaymentOption(String title, String subtitle) {
//     return Column(
//       children: [
//         Container(
//           width: 100,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
//         ),
//         SizedBox(height: 5),
//         Text(subtitle),
//       ],
//     );
//   }

//   // Fungsi untuk membuat opsi Loyalty Code
//   Widget _buildLoyaltyCodeOption(String title) {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image_picker/image_picker.dart';

// class QrPage extends StatefulWidget {
//   const QrPage({super.key});

//   @override
//   _QrPageState createState() => _QrPageState();
// }

// class _QrPageState extends State<QrPage> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;
//   CameraController? _cameraController;
//   List<CameraDescription>? cameras;
//   bool _isCameraInitialized = false;
//   String? _imagePath;

//   @override
//   void initState() {
//     super.initState();
//     _initCamera();
//   }

//   // Inisialisasi kamera
//   Future<void> _initCamera() async {
//     cameras = await availableCameras();
//     _cameraController = CameraController(cameras![0], ResolutionPreset.high);
//     await _cameraController!.initialize();
//     setState(() {
//       _isCameraInitialized = true;
//     });
//   }

//   // Fungsi untuk menangkap gambar dari kamera
//   // Future<void> _takePicture() async {
//   //   if (!_cameraController!.value.isInitialized) {
//   //     return;
//   //   }
//   //   try {
//   //     final Directory appDir = await getApplicationDocumentsDirectory();
//   //     final String picturePath = '${appDir.path}/${DateTime.now()}.jpg';
//   //     await _cameraController!.takePicture(picturePath);
//   //     setState(() {
//   //       _imagePath = picturePath;
//   //     });
//   //   } catch (e) {
//   //     print("Error taking picture: $e");
//   //   }
//   // }

//   Future<void> _takePicture() async {
//     if (!_cameraController!.value.isInitialized) {
//       return;
//     }
//     try {
//       // Mengambil gambar dan mendapatkan XFile
//       final XFile picture = await _cameraController!.takePicture();

//       setState(() {
//         _imagePath = picture.path; // Ambil path dari XFile
//       });
//     } catch (e) {
//       print("Error taking picture: $e");
//     }
//   }

//   // Fungsi untuk membuka galeri dan memilih gambar
//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile;
//     });
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QRIS Supported'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Bagian Kamera atau Preview Gambar
//           Expanded(
//             child: _isCameraInitialized
//                 ? CameraPreview(_cameraController!)
//                 : Center(child: CircularProgressIndicator()),
//           ),
//           // Tombol untuk menangkap gambar
//           Container(
//             padding: EdgeInsets.all(8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _takePicture,
//                   icon: Icon(Icons.camera),
//                   label: Text('Take Picture'),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: _pickImage,
//                   icon: Icon(Icons.upload_file),
//                   label: Text("Upload QR"),
//                 ),
//               ],
//             ),
//           ),
//           // Tampilkan gambar yang diambil atau diunggah
//           _imagePath != null
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.file(File(_imagePath!)),
//                 )
//               : _imageFile != null
//                   ? Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.file(File(_imageFile!.path)),
//                     )
//                   : Container(),
//           // Metode pembayaran tambahan (Alfamart, Indomaret, dll.)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               "Bisa juga bayar pakai",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildPaymentOption('Alfamart', 'Kode QRIS'),
//                 _buildPaymentOption('Indomaret', 'Kode Bayar'),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: _buildLoyaltyCodeOption('Loyalty Code'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Fungsi untuk membuat tombol pilihan pembayaran
//   Widget _buildPaymentOption(String title, String subtitle) {
//     return Column(
//       children: [
//         Container(
//           width: 100,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//               child:
//                   Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
//         ),
//         SizedBox(height: 5),
//         Text(subtitle),
//       ],
//     );
//   }

//   // Fungsi untuk membuat opsi Loyalty Code
//   Widget _buildLoyaltyCodeOption(String title) {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:clone_freelancer_mobile/views/User/add_card_page.dart';
import 'package:clone_freelancer_mobile/views/User/generate_qrcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result; // Untuk menyimpan hasil scan QR
  QRViewController? controller;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    // Mengunci layar dalam mode potret
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Mengembalikan orientasi ke default saat halaman ditutup
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    controller?.dispose();
    super.dispose();
  }

  // Fungsi untuk memindai QR code
  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      this.controller = qrController;
    });
    controller!.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          _handleQRResult(result!.code!);
        }
      });
    });
  }

  // Fungsi untuk menangani hasil QR code
  Future<void> _handleQRResult(String qrData) async {
    try {
      final response = await http.post(
        Uri.parse('https://payment-service-sbx.pakar-digital.com'),
        headers: {
          'Authorization': 'Bearer SB-Mid-client-wYeSigdies_2dI1d',
          'Content-Type': 'application/json',
        },
        body: '{"qrData": "$qrData"}',
      );
      if (response.statusCode == 200) {
        Get.snackbar('QR Scan Success', 'Redirecting to $qrData');
        // Mengarahkan ke URL atau halaman tertentu
        Get.to(() => PaymentPage(qrUrl: qrData));
      } else {
        Get.snackbar('QR Scan Failed', 'Failed to find QR source.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to scan QR code');
    }
  }

  // Fungsi untuk mengunggah gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Scan & Generate',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (result != null)
                  Text('Scan result: ${result!.code}')
                else
                  const Text('Scan a code'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload QR Code from Gallery'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     // Navigate to add card page
                //     Get.to(() => AddCardPage());
                //   },
                //   icon: const Icon(Icons.credit_card),
                //   label: const Text('Add Payment Card'),
                // ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke halaman generate QR
                    Get.to(() => HomePage());
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Generate QR Code'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman untuk pembayaran
class PaymentPage extends StatelessWidget {
  final String qrUrl;

  const PaymentPage({super.key, required this.qrUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Redirect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are being redirected to the payment page.'),
            Text('URL: $qrUrl'),
            ElevatedButton(
              onPressed: () {
                // bagian implementasi logika untuk pembayaran
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman dummy untuk menambahkan kartu pembayaran
// class AddCardPage extends StatelessWidget {
//   const AddCardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Payment Card'),
//       ),
//       body: Center(
//         child: Text('Add card functionality coming soon!'),
//       ),
//     );
//   }
// }


