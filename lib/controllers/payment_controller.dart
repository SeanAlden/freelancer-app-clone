// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:midtrans_sdk/midtrans_sdk.dart';

class PaymentController extends GetxController {
  MidtransSDK? _midtrans;
  final box = GetStorage();

  @override
  void onClose() {
    super.onClose();
    _midtrans?.removeTransactionFinishedCallback();
  }

  Future initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-wYeSigdies_2dI1d",
        // clientKey: "SB-Mid-client-v6-15hiE40WcarUI",
        colorTheme: ColorTheme(
          colorPrimary: Theme.of(Get.context!).colorScheme.secondary,
          colorPrimaryDark: Theme.of(Get.context!).colorScheme.secondary,
          colorSecondary: Theme.of(Get.context!).colorScheme.secondary,
        ),
        merchantBaseUrl: url,
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print(result.toJson());
    });
  }

  Future getTokenForCustomOrder({
    required int customId,
    required int serviceId,
    required String price,
    required int freelancerId,
  }) async {
    try {
      var data = {
        'custom_id': customId.toString(),
        'service_id': serviceId.toString(),
        'freelancer_id': freelancerId.toString(),
        'price': price,
        'name': box.read('user')['name'],
        'email': box.read('user')['email'],
      };

      var response = await http.post(
        Uri.parse('${url}midtrans/payment/custom_order'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        await initSDK();
        await _midtrans?.startPaymentUiFlow(
          token: data,
        );
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

// import 'package:clone_freelancer_mobile/constant/const.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentController extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentController> {
//   final _amountController = TextEditingController();
//   final _quantityController = TextEditingController();

//   Future<void> _createTransaction() async {
//     final amount = _amountController.text;
//     final quantity = _quantityController.text;

//     final response = await http.post(
//       // Uri.parse('https://a14d-203-189-122-12.ngrok-free.app/api/create-transaction'),
//       Uri.parse('${url}create-transaction'),
//       // Uri.parse('https://a0a5-203-189-122-12.ngrok-free.app/api/create-transaction'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': 'John Doe',
//         'email': 'john.doe@example.com',
//         'phone': '08123456789',
//         'quantity': int.parse(quantity),
//         'gross_amount': int.parse(amount),
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final snapToken = data['snapToken'];
//       final paymentUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

//       // Navigate to the new screen with the payment URL
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PaymentWebViewScreen(paymentUrl: paymentUrl),
//         ),
//       );
//     } else {
//       print('Error: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Midtrans Payment'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _amountController,
//               decoration: InputDecoration(
//                 labelText: 'Amount',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _quantityController,
//               decoration: InputDecoration(
//                 labelText: 'Quantity',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _createTransaction,
//             child: Text('Pay Now'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PaymentWebViewScreen extends StatelessWidget {
//   final String paymentUrl;

//   PaymentWebViewScreen({required this.paymentUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Midtrans Payment'),
//       ),
//       body: WebView(
//         initialUrl: paymentUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }