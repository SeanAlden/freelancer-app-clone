// import 'package:clone_freelancer_mobile/constant/const.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   final _amountController = TextEditingController();
//   final _quantityController = TextEditingController();

//   Future<void> _createTransaction() async {
//     final amount = _amountController.text;
//     final quantity = _quantityController.text;

//     final response = await http.post(
//       Uri.parse('${url}create-transaction'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': 'Sean',
//         'email': 'sean.alden@example.com',
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