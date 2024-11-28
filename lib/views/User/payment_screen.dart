import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:path/path.dart';
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
  final _phoneController = TextEditingController();
  final _quantityController = TextEditingController();

  Future<void> _createTransaction() async {
    final phone = _phoneController.text;
    final quantity = _quantityController.text;

    final response = await http.post(
      Uri.parse('https://wearableprojects.petra.ac.id/api/create-transaction'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': widget.name,
        'email': widget.email,
        'phone': 0.toString(),
        // 'phone': int.parse(phone).toString(),
        'quantity': int.parse(quantity),
        'gross_amount': widget.price,

        // 'name': name,
        // 'email': email,
        // 'package_name': packageName,
        // 'service_name': serviceName,
        // 'price': price,
        // 'gross_amount': price,
        // 'merchant_name': merchantName,
        // 'sub_category': subCategory

        // 'package_id': packageId.toString(),
        // 'price': price.toString(),
        // 'service_name': serviceName,
        // 'package_name': packageName,
        // 'sub_category': subCategoryName,
        // 'merchant_name': merchantName,
        // 'seller_id': widget.user.userId.toString(),
        // if (dateTemp != null) 'onsite_date': dateTemp.toIso8601String(),
        // if (latlng != null) 'lat': latlng.latitude.toString(),
        // if (latlng != null) 'lng': latlng.longitude.toString(),
        // if (loc != null) 'loc': loc,
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
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Name: ${widget.name}', style: TextStyle(fontSize: 16)),
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
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     controller: _phoneController,
            //     decoration: InputDecoration(
            //       labelText: 'Phone',
            //     ),
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
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
                  // TODO: Add payment logic
                  print('Pay Now button pressed');
                },
                child: Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentWebViewScreen extends StatelessWidget {
  final String paymentUrl;

  PaymentWebViewScreen({required this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Midtrans Payment'),
      ),
      body: WebView(
        initialUrl: paymentUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
