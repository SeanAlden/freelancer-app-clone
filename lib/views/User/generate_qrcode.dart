// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr/qr.dart';

// class GenerateQrCodePage extends StatefulWidget {
//   @override
//   _GenerateQrCodePageState createState() => _GenerateQrCodePageState();
// }

// class _GenerateQrCodePageState extends State<GenerateQrCodePage> {
//   final TextEditingController _paymentIdController = TextEditingController();
//   String? _generatedQrData;

//   @override
//   void dispose() {
//     _paymentIdController.dispose();
//     super.dispose();
//   }

//   // Fungsi untuk menghasilkan QR Code dari input user
//   void _generateQrCode() {
//     final String paymentId = _paymentIdController.text.trim();
//     if (paymentId.isNotEmpty) {
//       setState(() {
//         // Contoh data QRIS yang digenerate (bisa sesuaikan dengan standar QRIS)
//         _generatedQrData = 'qris://payment/$paymentId';
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid payment ID')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Generate QR Code for QRIS'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _paymentIdController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Payment ID',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _generateQrCode,
//               child: const Text('Generate QR Code'),
//             ),
//             const SizedBox(height: 20),
//             if (_generatedQrData != null)
//               QrImage(
//                 data: _generatedQrData!,
//                 version: QrVersions.auto,
//                 size: 200.0,
//               ),
//             const SizedBox(height: 20),
//             if (_generatedQrData != null)
//               Text('QR Data: $_generatedQrData', textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:clone_freelancer_mobile/core.dart';
// import 'package:clone_freelancer_mobile/views/User/Search/result_page.dart';
import 'package:clone_freelancer_mobile/views/User/result_qr.dart';
import 'package:flutter/material.dart';
// import 'package:generate_qr_code/result_qr.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext contexr) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(255, 93, 82, 255),
          title: const Text("QR Code"),
          centerTitle: true,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              onChanged: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.cancel, color: Colors.red))
                    : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 93, 82, 255), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Input your text',
                labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width * 0.30,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 93, 82, 255)),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (controller.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Ups, inputan tidak boleh kosong!',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          backgroundColor: Colors.red,
                          shape: StadiumBorder(),
                          behavior: SnackBarBehavior.floating,
                        ));
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) {
                            return ResultQRPage(controller);
                          }),
                        ));
                      }
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    'Generate QR Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
