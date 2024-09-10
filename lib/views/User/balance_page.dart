// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:clone_freelancer_mobile/views/User/withdraw_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future futureBalance;
  late Future futureTransaction;
  final box = GetStorage();
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print('Fetching data');
    setState(() {
      futureBalance = userController.getBalance();
      futureTransaction = userController.getTransaction();
    });
  }

  void openCustomOrderDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => WithdrawDialog(
        onClose: (result) {
          Navigator.pop(context, result);
        },
      ),
    );

    if (result != null) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Wallet'),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: futureBalance,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  var data = snapshot.data;
                  MoneyFormatter fmf = MoneyFormatter(
                          amount: double.parse(data['balance'].toString()))
                      .copyWith(symbol: 'IDR');
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Balance',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            fmf.output.symbolOnLeft,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Transaction History'),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: futureTransaction,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.data == null ||
                              snapshot.data.isEmpty) {
                            return const Center(
                              child: Text('No Transactions'),
                            );
                          } else {
                            var data = snapshot.data;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                double number =
                                    double.parse(data[index]['amount']);
                                int value = number.toInt().abs();
                                MoneyFormatter fmf = MoneyFormatter(
                                        amount: double.parse(value.toString()))
                                    .copyWith(symbol: 'IDR');

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        data[index]['type'] ==
                                                    'client_refund' ||
                                                data[index]['type'] ==
                                                    'freelancer_payout'
                                            ? const FaIcon(
                                                FontAwesomeIcons.plus,
                                                color: Colors.green,
                                              )
                                            : const FaIcon(
                                                FontAwesomeIcons.minus,
                                                color: Colors.red,
                                              ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(data[index]['type']),
                                      ],
                                    ),
                                    Text(
                                      fmf.output.symbolOnLeft,
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      openCustomOrderDialog(context);
                    },
                    child: const Text('Withdraw Balance'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
