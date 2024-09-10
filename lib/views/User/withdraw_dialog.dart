// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class WithdrawDialog extends StatefulWidget {
  const WithdrawDialog({super.key, this.onClose});
  final Function(dynamic)? onClose;

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class Bank {
  final String code;
  final String name;

  Bank({required this.code, required this.name});
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  late Future futureBalance;
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;
  final box = GetStorage();
  final UserController userController = Get.put(UserController());
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<Bank> banks = [
    Bank(code: 'aceh', name: 'PT. BANK ACEH'),
    Bank(code: 'aceh_syar', name: 'PT. BPD ISTIMEWA ACEH SYARIAH'),
    Bank(code: 'agris', name: 'PT. BANK AGRIS'),
    Bank(code: 'agroniaga', name: 'PT. BANK RAKYAT INDONESIA AGRONIAGA TBK.'),
    Bank(code: 'allo', name: 'PT. ALLO BANK INDONESIA TBK.'),
    Bank(code: 'amar', name: 'PT. BANK AMAR INDONESIA'),
    Bank(code: 'andara', name: 'PT. BANK ANDARA'),
    Bank(code: 'anglomas', name: 'PT. ANGLOMAS INTERNATIONAL BANK'),
    Bank(code: 'antar_daerah', name: 'PT. BANK ANTAR DAERAH'),
    Bank(code: 'anz', name: 'PT. BANK ANZ INDONESIA'),
    Bank(code: 'artajasa', name: 'PT. ARTAJASA'),
    Bank(code: 'artha', name: 'PT. BANK ARTHA GRAHA INTERNASIONAL TBK.'),
    Bank(code: 'bali', name: 'PT. BANK PEMBANGUNAN DAERAH BALI'),
    Bank(code: 'bangkok', name: 'BANGKOK BANK PUBLIC CO.LTD'),
    Bank(code: 'banten', name: 'PT. BANK BANTEN'),
    Bank(code: 'barclays', name: 'PT BANK BARCLAYS INDONESIA'),
    Bank(code: 'bca', name: 'PT. BANK CENTRAL ASIA TBK.'),
    Bank(code: 'bcad', name: 'PT. BANK DIGITAL BCA'),
    Bank(code: 'bca_syar', name: 'PT. BANK BCA SYARIAH'),
    // Add more banks here as needed
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      futureBalance = userController.getBalance();
    });
  }

  Future withdrawBalance({
    required String accountName,
    required String accountNumber,
    required String bankCode,
    required String amount,
  }) async {
    try {
      var data = {
        'account_name': accountName,
        'account_number': accountNumber,
        'bank': bankCode,
        'amount': amount,
      };
      var response = await http.post(
        Uri.parse('${url}withdrawBalance'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Navigator.of(context).pop(true);
        return data;
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

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Withdraw')),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Account Name",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextSpan(
                              text: "*",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: accountName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Account Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Account Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Account Number",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextSpan(
                              text: "*",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: accountNumber,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Account number is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Account Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Bank",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextSpan(
                              text: "*",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          hint: const Text("Select Bank"),
                          items: banks.map((Bank bank) {
                            return DropdownMenuItem<String>(
                              value: bank.code,
                              child: Text(bank.name),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Bank is required';
                            }
                            return null;
                          },
                          value: selectedBank,
                          onChanged: (String? value) {
                            setState(() {
                              selectedBank = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 56,
                            padding: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility:
                                  MaterialStateProperty.all<bool>(true),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                            padding: EdgeInsets.only(left: 22, right: 0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Amount",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextSpan(
                              text: "*",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Amount",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await withdrawBalance(
                              accountName: accountName.text.trim(),
                              accountNumber: accountNumber.text.trim(),
                              bankCode: selectedBank!,
                              amount: amountController.text.trim(),
                            );
                          }
                        },
                        child: const Text('Withdraw Balance'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
