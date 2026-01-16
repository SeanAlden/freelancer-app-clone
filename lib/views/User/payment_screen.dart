import 'dart:convert';

import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String email;
  final String packageName;
  final String serviceName;
  final int price;
  final String merchantName;
  final String subCategory;

  PaymentScreen({
    required this.name,
    required this.email,
    required this.packageName,
    required this.serviceName,
    required this.price,
    required this.merchantName,
    required this.subCategory,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // final _phoneController = TextEditingController();
  final _quantityController = TextEditingController();
  final box = GetStorage();

  Future<void> _createTransaction() async {
    // final phone = _phoneController.text;
    final quantity = _quantityController.text;

    final response = await http.post(
      Uri.parse('${url}create-transaction'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      },
      body: jsonEncode({
        'name': widget.name,
        'email': widget.email,
        'phone': 0.toString(),
        // 'phone': int.parse(phone).toString(),
        'quantity': int.parse(quantity),
        'gross_amount': widget.price,
        'freelancer_id': 1
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final snapToken = data['snapToken'];
      final paymentUrl =
          // Sandbox
          'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';
      print(paymentUrl);
      // Production
      // 'https://app.midtrans.com/snap/v2/vtweb/$snapToken';
      // Navigate to the new screen with the payment URL
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebViewScreen(paymentUrl: paymentUrl),
          ));
    } else {
      // print('Error: ${response.body}');

      final err = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Payment Error'),
          content: Text(err['error'] ?? 'Unknown error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Client Name: ${widget.name}',
                  style: TextStyle(fontSize: 16)),
              Text('Client Email: ${widget.email}',
                  style: TextStyle(fontSize: 16)),
              Text('Package Name: ${widget.packageName}',
                  style: TextStyle(fontSize: 16)),
              Text('Service Name: ${widget.serviceName}',
                  style: TextStyle(fontSize: 16)),
              Text('Price: \$${widget.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16)),
              Text('Freelancer Name: ${widget.merchantName}',
                  style: TextStyle(fontSize: 16)),
              Text('Sub Category: ${widget.subCategory}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _createTransaction();
                    print('Pay Now button pressed');
                  },
                  child: Text('Pay Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

// class PaymentWebViewScreen extends StatefulWidget {
//   final String paymentUrl;

//   const PaymentWebViewScreen({super.key, required this.paymentUrl});

//   @override
//   State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
// }

// class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(Uri.parse(widget.paymentUrl));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Midtrans Payment')),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const PaymentWebViewScreen({super.key, required this.paymentUrl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            print('Redirected to: $url');

            if (url.contains('transaction_status=settlement') ||
                url.contains('transaction_status=capture')) {
              _onPaymentSuccess();
              return NavigationDecision.prevent;
            }

            if (url.contains('transaction_status=cancel') ||
                url.contains('transaction_status=expire')) {
              _onPaymentFailed();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _onPaymentSuccess() {
    Navigator.of(context).pop(true); // return success
  }

  void _onPaymentFailed() {
    Navigator.of(context).pop(false); // return failed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Screen')),
      body: WebViewWidget(controller: controller),
    );
  }
}

