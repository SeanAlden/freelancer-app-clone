// ignore_for_file: avoid_print

import 'package:clone_freelancer_mobile/views/User/payment_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/launch_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:rating_dialog/rating_dialog.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({super.key});

  @override
  State<ListOrderPage> createState() => _ListOrderPageState();
}

class _ListOrderPageState extends State<ListOrderPage> {
  late Future futureListOrder;
  final ServiceController serviceController = Get.put(ServiceController());
  final ChatController chatController = Get.put(ChatController());
  final UserController userController = Get.put(UserController());
  TextEditingController noteController = TextEditingController();
  String status = 'all';
  final box = GetStorage();
  final PusherService _pusherService = PusherService();
  MidtransSDK? _midtrans;
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
    _pusherService.disconnet();
  }

  void onNewMessage(PusherEvent event) {
    fetchData();
  }

  void connect() {
    _pusherService.addEventListener('order.update', onNewMessage);
    _pusherService.connetToPusher(
        channelName: 'update.${box.read('user')['user_id']}');
  }

  void fetchData() async {
    print('Fetching data');
    setState(() {
      futureListOrder = serviceController.getAllOrders(status: status);
    });
  }

  Future initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        // Sandbox
        clientKey: clientUrlSandbox,
        // Production
        // clientKey: clientUrlProduction,
        colorTheme: ColorTheme(
          colorPrimary: Theme.of(context).colorScheme.secondary,
          colorPrimaryDark: Theme.of(context).colorScheme.secondary,
          colorSecondary: Theme.of(context).colorScheme.secondary,
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

  Future showRatingDialog({
    required String freelancerName,
    required String orderId,
    required String freelancerId,
    required String serviceId,
    required String broadcast,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => RatingDialog(
        initialRating: 4.0,
        title: Text(
          'experience_question'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        message: Text(
          'feedback_help'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        image: const FlutterLogo(size: 100),
        submitButtonText: 'submit'.tr,
        commentHint: 'write_review'.tr,
        onCancelled: () => print('cancelled'),
        onSubmitted: (response) {
          print('rating: ${response.rating}, comment: ${response.comment}');
          userController.sendReview(
            orderId: orderId,
            freelancerId: freelancerId,
            rating: response.rating.toString(),
            comment: response.comment,
            serviceId: serviceId,
            broadcast: broadcast,
          );
        },
      ),
    );
  }

  Future showRevisionDialog(String orderId) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: noteController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'type_message'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'describe_changes'.tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text('no'.tr),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await userController.sendRevisionRequest(
                  orderId: orderId,
                  comment: noteController.text.trim(),
                );
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text('yes'.tr),
          ),
        ],
        title: Text('revision_details'.tr),
      ),
    ).then((value) {
      noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'manage_order'.tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            isScrollable: true,
            onTap: (value) {
              switch (value) {
                case 0:
                  setState(() {
                    status = 'all';
                  });
                  break;
                case 1:
                  setState(() {
                    status = 'awaiting payment';
                  });
                  break;
                case 2:
                  setState(() {
                    status = 'pending';
                  });
                  break;
                case 3:
                  setState(() {
                    status = 'in progress';
                  });
                  break;
                case 4:
                  setState(() {
                    status = 'delivered';
                  });
                  break;
                case 5:
                  setState(() {
                    status = 'revision requested';
                  });
                  break;
                case 6:
                  setState(() {
                    status = 'completed';
                  });
                  break;
                case 7:
                  setState(() {
                    status = 'cancelled';
                  });
                  break;
                default:
                  setState(() {
                    status = 'all';
                  });
                  break;
              }
              fetchData();
            },
            tabs: <Widget>[
              Tab(
                text: 'all'.tr,
              ),
              Tab(
                text: 'awaiting_payment'.tr,
              ),
              Tab(
                text: 'pending'.tr,
              ),
              Tab(
                text: 'in_progress'.tr,
              ),
              Tab(
                text: 'delivered'.tr,
              ),
              Tab(
                text: 'revision_request'.tr,
              ),
              Tab(
                text: 'completed'.tr,
              ),
              Tab(
                text: 'cancelled'.tr,
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FutureBuilder(
            future: futureListOrder,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Loading indicator while waiting for data
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return Center(child: Text('no_data'.tr));
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DateTime parsedExpirationDate = DateTime.now();
                    if (data[index]['due_date'] != null) {
                      parsedExpirationDate =
                          DateTime.parse(data[index]['due_date']);
                    }
                    var linkServicePic = data[index]['servicePic']['picasset'];
                    linkServicePic =
                        url.replaceFirst('/api/', '') + linkServicePic;
                    String linkAvatar = data[index]['picasset'];
                    linkAvatar = url.replaceFirst('/api/', '') + linkAvatar;
                    // MoneyFormatter fmf = MoneyFormatter(
                    //         amount: double.parse(data[index]['price']))
                    //     .copyWith(symbol: 'IDR');

                    final NumberFormat currencyFormatter =
                        NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'IDR ',
                      decimalDigits: 0,
                    );

                    String formattedPrice = currencyFormatter.format(
                      double.tryParse(data[index]['price'].toString()) ?? 0,
                    );

                    var status = data[index]['order_status'];
                    return Card(
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            status == 'awaiting payment'
                                ? CountdownTimer(
                                    endTime: parsedExpirationDate
                                        .millisecondsSinceEpoch,
                                    widgetBuilder: (context, time) {
                                      if (time == null) {
                                        return Text(
                                          'order_cancelled'.tr,
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                                            ),
                                            // PopupMenuButton(
                                            //   itemBuilder: (context) {
                                            //     return [
                                            //       const PopupMenuItem(
                                            //         value: '0',
                                            //         child: Text('Cancel'),
                                            //       ),
                                            //       const PopupMenuItem(
                                            //         value: '1',
                                            //         child: Text('Pay Now'),
                                            //       ),
                                            //     ];
                                            //   },
                                            //   onSelected: (String value) async {
                                            //     if (value == '0') {
                                            //       showDialog(
                                            //         context: context,
                                            //         builder: (context) =>
                                            //             AlertDialog(
                                            //           actions: [
                                            //             TextButton(
                                            //               onPressed: () {
                                            //                 Navigator.of(
                                            //                         context)
                                            //                     .pop();
                                            //               },
                                            //               child: Text('no'.tr),
                                            //             ),
                                            //             TextButton(
                                            //               onPressed: () async {
                                            //                 await userController
                                            //                     .cancelOrder(
                                            //                         orderId: data[index]
                                            //                                 [
                                            //                                 'order_id']
                                            //                             .toString())
                                            //                     .then((value) =>
                                            //                         Navigator.of(
                                            //                                 context)
                                            //                             .pop());
                                            //               },
                                            //               child: Text('yes'.tr),
                                            //             ),
                                            //           ],
                                            //           title: Text(
                                            //               'cancel_order_question'
                                            //                   .tr),
                                            //         ),
                                            //       );
                                            //     } else {
                                            //       print(data[index]);
                                            //       // await initSDK();
                                            //       // await _midtrans
                                            //       //     ?.startPaymentUiFlow(
                                            //       //   token: data[index]['token'],
                                            //       // );
                                            //     }
                                            //   },
                                            // ),

                                            // PopupMenuButton(
                                            //   itemBuilder: (context) {
                                            //     return [
                                            //       const PopupMenuItem(
                                            //         value: '0',
                                            //         child: Text('Cancel'),
                                            //       ),
                                            //       const PopupMenuItem(
                                            //         value: '1',
                                            //         child: Text('Pay Now'),
                                            //       ),
                                            //     ];
                                            //   },
                                            //   onSelected: (String value) async {
                                            //     if (value == '0') {
                                            //       // cancel logic
                                            //       showDialog(
                                            //         context: context,
                                            //         builder: (context) =>
                                            //             AlertDialog(
                                            //           title: Text(
                                            //               'cancel_order_question'
                                            //                   .tr),
                                            //           actions: [
                                            //             TextButton(
                                            //               onPressed: () =>
                                            //                   Navigator.of(
                                            //                           context)
                                            //                       .pop(),
                                            //               child: Text('no'.tr),
                                            //             ),
                                            //             TextButton(
                                            //               onPressed: () async {
                                            //                 await userController
                                            //                     .cancelOrder(
                                            //                         orderId: data[index]
                                            //                                 [
                                            //                                 'order_id']
                                            //                             .toString())
                                            //                     .then((value) =>
                                            //                         Navigator.of(
                                            //                                 context)
                                            //                             .pop());
                                            //               },
                                            //               child: Text('yes'.tr),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       );
                                            //     } else if (value == '1') {
                                            //       // Pay Now logic
                                            //       final snapToken = data[index][
                                            //           'snap_token']; // ambil snap token dari API
                                            //       final paymentUrl =
                                            //           'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

                                            //       // Panggil WebView popup yang sama
                                            //       final result =
                                            //           await showDialog<bool>(
                                            //         context: context,
                                            //         builder: (context) =>
                                            //             Dialog(
                                            //           insetPadding:
                                            //               EdgeInsets.all(0),
                                            //           backgroundColor:
                                            //               Colors.transparent,
                                            //           child: SizedBox(
                                            //             width: MediaQuery.of(
                                            //                     context)
                                            //                 .size
                                            //                 .width,
                                            //             height: MediaQuery.of(
                                            //                     context)
                                            //                 .size
                                            //                 .height,
                                            //             child:
                                            //                 PaymentWebViewScreen(
                                            //                     paymentUrl:
                                            //                         paymentUrl),
                                            //           ),
                                            //         ),
                                            //       );

                                            //       // result akan true jika sukses, false jika gagal/cancel
                                            //       if (result == true) {
                                            //         Get.snackbar(
                                            //           'Payment Success',
                                            //           'Order has been paid successfully',
                                            //           backgroundColor:
                                            //               Colors.green,
                                            //           colorText: Colors.white,
                                            //         );
                                            //       } else if (result == false) {
                                            //         Get.snackbar(
                                            //           'Payment Failed',
                                            //           'Payment was cancelled or failed',
                                            //           backgroundColor:
                                            //               Colors.red,
                                            //           colorText: Colors.white,
                                            //         );
                                            //       }
                                            //     }
                                            //   },
                                            // )

                                            PopupMenuButton(
                                              itemBuilder: (context) {
                                                return const [
                                                  PopupMenuItem(
                                                    value: '0',
                                                    child: Text('Cancel'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: '1',
                                                    child: Text('Pay Now'),
                                                  ),
                                                ];
                                              },
                                              onSelected: (String value) async {
                                                if (value == '0') {
                                                  // ===== CANCEL ORDER =====
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                          'cancel_order_question'
                                                              .tr),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Text('no'.tr),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              await userController
                                                                  .cancelOrder(
                                                                orderId: data[
                                                                            index]
                                                                        [
                                                                        'order_id']
                                                                    .toString(),
                                                              );
                                                            } catch (e) {
                                                              Get.snackbar(
                                                                'Error',
                                                                'Failed to cancel order',
                                                                backgroundColor:
                                                                    Colors.red,
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                              );
                                                            } finally {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // tutup dialog
                                                              setState(() {
                                                                fetchData(); // reload halaman utama
                                                              });
                                                            }
                                                          },
                                                          child: Text('yes'.tr),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else if (value == '1') {
                                                  // ===== PAY NOW =====
                                                  final snapToken =
                                                      data[index]['snap_token'];

                                                  // Sandbox
                                                  final paymentUrl =
                                                      '${sandboxUrl}snap/v2/vtweb/$snapToken';

                                                  // Production
                                                  // final paymentUrl =
                                                  //     '${productionUrl}snap/v2/vtweb/$snapToken';

                                                  // final result =
                                                  //     await showDialog<bool>(
                                                  //   context: context,
                                                  //   builder: (context) =>
                                                  //       Dialog(
                                                  //     insetPadding:
                                                  //         EdgeInsets.zero,
                                                  //     backgroundColor:
                                                  //         Colors.transparent,
                                                  //     child: SizedBox(
                                                  //       width: MediaQuery.of(
                                                  //               context)
                                                  //           .size
                                                  //           .width,
                                                  //       height: MediaQuery.of(
                                                  //               context)
                                                  //           .size
                                                  //           .height,
                                                  //       child:
                                                  //           PaymentWebViewScreen(
                                                  //               paymentUrl:
                                                  //                   paymentUrl),
                                                  //     ),
                                                  //   ),
                                                  // );

                                                  final result = await Navigator
                                                      .push<bool>(
                                                    context,
                                                    MaterialPageRoute(
                                                      fullscreenDialog: true,
                                                      builder: (_) =>
                                                          PaymentWebViewScreen(
                                                        paymentUrl: paymentUrl,
                                                      ),
                                                    ),
                                                  );

                                                  try {
                                                    if (result == true) {
                                                      Get.snackbar(
                                                        'Payment Success',
                                                        'Order has been paid successfully',
                                                        backgroundColor:
                                                            Colors.green,
                                                        colorText: Colors.white,
                                                      );
                                                    } else if (result ==
                                                        false) {
                                                      Get.snackbar(
                                                        'Payment Failed',
                                                        'Please choose a payment method',
                                                        backgroundColor:
                                                            Colors.red,
                                                        colorText: Colors.white,
                                                      );
                                                    }
                                                  } finally {
                                                    // selalu reload setelah WebView ditutup
                                                    setState(() {
                                                      fetchData();
                                                    });
                                                  }
                                                }
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    },
                                  )
                                : status == 'pending'
                                    ? CountdownTimer(
                                        endTime: parsedExpirationDate
                                            .millisecondsSinceEpoch,
                                        widgetBuilder: (context, time) {
                                          if (time == null) {
                                            return Text(
                                              'order_cancelled'.tr,
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            );
                                          } else {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Estimated confirmation ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                                                  ),
                                                ),
                                                // PopupMenuButton(
                                                //   itemBuilder: (context) {
                                                //     return [
                                                //       PopupMenuItem(
                                                //         value: '0',
                                                //         child:
                                                //             Text('cancel'.tr),
                                                //       ),
                                                //       if (data[index][
                                                //                   'order_status'] ==
                                                //               'awaiting payment' ||
                                                //           data[index][
                                                //                   'order_status'] ==
                                                //               'pending')
                                                //         PopupMenuItem(
                                                //           value: '1',
                                                //           child: Text(
                                                //               'pay_now'.tr),
                                                //         ),
                                                //     ];
                                                //   },
                                                //   onSelected:
                                                //       (String value) async {
                                                //     if (value == '0') {
                                                //       showDialog(
                                                //         context: context,
                                                //         builder: (context) =>
                                                //             AlertDialog(
                                                //           content: const Text(
                                                //               'Refunded funds will be automatically credited to your balance. You can use this balance for future purchases or withdrawals.'),
                                                //           actions: [
                                                //             TextButton(
                                                //               onPressed: () {
                                                //                 Navigator.of(
                                                //                         context)
                                                //                     .pop();
                                                //               },
                                                //               child:
                                                //                   Text('no'.tr),
                                                //             ),
                                                //             TextButton(
                                                //               onPressed:
                                                //                   () async {
                                                //                 await userController
                                                //                     .cancelRefundOrder(
                                                //                         orderId:
                                                //                             data[index]['order_id']
                                                //                                 .toString())
                                                //                     .then((value) =>
                                                //                         Navigator.of(context)
                                                //                             .pop());
                                                //               },
                                                //               child: Text(
                                                //                   'yes'.tr),
                                                //             ),
                                                //           ],
                                                //           title: Text(
                                                //               'cancel_order_question'
                                                //                   .tr),
                                                //         ),
                                                //       );
                                                //     } else if (value == '1') {
                                                //       // Pay Now logic
                                                //       final snapToken = data[
                                                //               index][
                                                //           'snap_token']; // ambil snap token dari API
                                                //       final paymentUrl =
                                                //           'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

                                                //       // Panggil WebView popup yang sama
                                                //       final result =
                                                //           await showDialog<
                                                //               bool>(
                                                //         context: context,
                                                //         builder: (context) =>
                                                //             Dialog(
                                                //           insetPadding:
                                                //               EdgeInsets.all(0),
                                                //           backgroundColor:
                                                //               Colors
                                                //                   .transparent,
                                                //           child: SizedBox(
                                                //             width:
                                                //                 MediaQuery.of(
                                                //                         context)
                                                //                     .size
                                                //                     .width,
                                                //             height:
                                                //                 MediaQuery.of(
                                                //                         context)
                                                //                     .size
                                                //                     .height,
                                                //             child: PaymentWebViewScreen(
                                                //                 paymentUrl:
                                                //                     paymentUrl),
                                                //           ),
                                                //         ),
                                                //       );

                                                //       // result akan true jika sukses, false jika gagal/cancel
                                                //       if (result == true) {
                                                //         Get.snackbar(
                                                //           'Payment Success',
                                                //           'Order has been paid successfully',
                                                //           backgroundColor:
                                                //               Colors.green,
                                                //           colorText:
                                                //               Colors.white,
                                                //         );
                                                //       } else if (result ==
                                                //           false) {
                                                //         Get.snackbar(
                                                //           'Payment Failed',
                                                //           'Payment was cancelled or failed',
                                                //           backgroundColor:
                                                //               Colors.red,
                                                //           colorText:
                                                //               Colors.white,
                                                //         );
                                                //       }
                                                //     }
                                                //   },
                                                // )

                                                PopupMenuButton(
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem(
                                                        value: '0',
                                                        child:
                                                            Text('cancel'.tr),
                                                      ),
                                                      if (data[index][
                                                                  'order_status'] ==
                                                              'awaiting payment' ||
                                                          data[index][
                                                                  'order_status'] ==
                                                              'pending')
                                                        PopupMenuItem(
                                                          value: '1',
                                                          child: Text(
                                                              'pay_now'.tr),
                                                        ),
                                                    ];
                                                  },
                                                  onSelected:
                                                      (String value) async {
                                                    if (value == '0') {
                                                      // ===== CANCEL + REFUND =====
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'cancel_order_question'
                                                                  .tr),
                                                          content: const Text(
                                                            'Refunded funds will be automatically credited to your balance. You can use this balance for future purchases or withdrawals.',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child:
                                                                  Text('no'.tr),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await userController
                                                                      .cancelRefundOrder(
                                                                    orderId: data[index]
                                                                            [
                                                                            'order_id']
                                                                        .toString(),
                                                                  );
                                                                } catch (e) {
                                                                  Get.snackbar(
                                                                    'Error',
                                                                    'Failed to cancel order',
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    colorText:
                                                                        Colors
                                                                            .white,
                                                                  );
                                                                } finally {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // tutup dialog
                                                                  setState(() {
                                                                    fetchData(); // reload halaman utama
                                                                  });
                                                                }
                                                              },
                                                              child: Text(
                                                                  'yes'.tr),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else if (value == '1') {
                                                      // ===== PAY NOW =====
                                                      final snapToken =
                                                          data[index]
                                                              ['snap_token'];

                                                      // Sandbox
                                                      final paymentUrl =
                                                          '${sandboxUrl}snap/v2/vtweb/$snapToken';

                                                      // Production
                                                      // final paymentUrl =
                                                      //     '${productionUrl}snap/v2/vtweb/$snapToken';

                                                      // final result =
                                                      //     await showDialog<
                                                      //         bool>(
                                                      //   context: context,
                                                      //   builder: (context) =>
                                                      //       Dialog(
                                                      //     insetPadding:
                                                      //         EdgeInsets.zero,
                                                      //     backgroundColor:
                                                      //         Colors
                                                      //             .transparent,
                                                      //     child: SizedBox(
                                                      //       width:
                                                      //           MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .width,
                                                      //       height:
                                                      //           MediaQuery.of(
                                                      //                   context)
                                                      //               .size
                                                      //               .height,
                                                      //       child: PaymentWebViewScreen(
                                                      //           paymentUrl:
                                                      //               paymentUrl),
                                                      //     ),
                                                      //   ),
                                                      // );

                                                      final result =
                                                          await Navigator.push<
                                                              bool>(
                                                        context,
                                                        MaterialPageRoute(
                                                          fullscreenDialog:
                                                              true,
                                                          builder: (_) =>
                                                              PaymentWebViewScreen(
                                                            paymentUrl:
                                                                paymentUrl,
                                                          ),
                                                        ),
                                                      );

                                                      try {
                                                        if (result == true) {
                                                          Get.snackbar(
                                                            'Payment Success',
                                                            'Order has been paid successfully',
                                                            backgroundColor:
                                                                Colors.green,
                                                            colorText:
                                                                Colors.white,
                                                          );
                                                        } else if (result ==
                                                            false) {
                                                          Get.snackbar(
                                                            'Payment Failed',
                                                            'Payment was pending because user cancelled or failed',
                                                            backgroundColor:
                                                                Colors.red,
                                                            colorText:
                                                                Colors.white,
                                                          );
                                                        }
                                                      } finally {
                                                        // selalu reload setelah WebView ditutup
                                                        setState(() {
                                                          fetchData();
                                                        });
                                                      }
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      )
                                    : status == 'in progress'
                                        ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CountdownTimer(
                                                endTime: parsedExpirationDate
                                                    .millisecondsSinceEpoch,
                                                widgetBuilder: (context, time) {
                                                  if (time == null) {
                                                    return Text(
                                                      'late'.tr,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  } else {
                                                    return Row(
                                                      children: [
                                                        Text(
                                                          'Estimated delivery time ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                                                        ),
                                                        
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                              Row(
                                                      children: [
                                              TextButton(
                                                // onPressed: status ==
                                                //         'in progress'
                                                //     ? () {
                                                //         // setState(() {
                                                //         //   status =
                                                //         //       'delivered';
                                                //         // });
                                                //         setState(() {
                                                //           data[index][
                                                //                   'order_status'] =
                                                //               'delivered';
                                                //         });
                                                //       }
                                                //     : null, // tombol disable kalau bukan in progress

                                                onPressed: () async {
                                                  setState(() {
                                                    data[index]
                                                            ['order_status'] =
                                                        'delivered';
                                                  });

                                                  try {
                                                    await userController
                                                        .markAsDelivered(
                                                      orderId: data[index]
                                                          ['order_id'],
                                                    );
                                                  } catch (_) {
                                                    // rollback jika gagal
                                                    setState(() {
                                                      data[index]
                                                              ['order_status'] =
                                                          'in progress';
                                                    });
                                                  } finally {
                                                    setState(() {
                                                      // reload halaman utama (selalu jalan)
                                                      fetchData();
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'Delivered',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              )
                                                      ])
                                            ],
                                          )

//                                         Row(
//   children: [
//     Expanded(
//       child: Text(
//         'Estimated delivery time '
//         '${time.days != null ? '${time.days} days ' : ''}'
//         '${(time.hours ?? 0).toString().padLeft(2, '0')}:'
//         '${(time.min ?? 0).toString().padLeft(2, '0')}:'
//         '${(time.sec ?? 0).toString().padLeft(2, '0')}',
//         overflow: TextOverflow.ellipsis,
//       ),
//     ),
//     const SizedBox(width: 4),
//     Align(
//       alignment: Alignment.centerRight,
//       child: TextButton(
//         onPressed: () async {
//           setState(() {
//             data[index]['order_status'] = 'delivered';
//           });

//           try {
//             await userController.markAsDelivered(
//               orderId: data[index]['order_id'],
//             );
//           } catch (_) {
//             setState(() {
//               data[index]['order_status'] = 'in progress';
//             });
//           } finally {
//             fetchData();
//           }
//         },
//         child: const Text(
//           'Delivered',
//           style: TextStyle(color: Colors.green),
//         ),
//       ),
//     ),
//   ],
// )

                                        : status == 'revision requested'
                                            ? CountdownTimer(
                                                endTime: parsedExpirationDate
                                                    .millisecondsSinceEpoch,
                                                widgetBuilder: (context, time) {
                                                  if (time == null) {
                                                    return Text(
                                                      'late'.tr,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      'Estimated confirmation ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                                                    );
                                                  }
                                                },
                                              )
                                            : status == 'completed'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(data[index]
                                                          ['updated_at']),
                                                      data[index]['fileCount'] ==
                                                                  1 ||
                                                              data[index][
                                                                      'reviewStatus'] !=
                                                                  'available'
                                                          ? PopupMenuButton(
                                                              itemBuilder:
                                                                  (context) {
                                                                return [
                                                                  if (data[index]
                                                                          [
                                                                          'fileCount'] ==
                                                                      1)
                                                                    const PopupMenuItem(
                                                                      value:
                                                                          '0',
                                                                      child:
                                                                          Text(
                                                                        'Download File',
                                                                      ),
                                                                    ),
                                                                  if (data[index]
                                                                          [
                                                                          'reviewStatus'] !=
                                                                      'available')
                                                                    const PopupMenuItem(
                                                                      value:
                                                                          '1',
                                                                      child:
                                                                          Text(
                                                                        'Review Order',
                                                                      ),
                                                                    ),
                                                                  if (data[index]
                                                                          [
                                                                          'reportCount'] ==
                                                                      0)
                                                                    const PopupMenuItem(
                                                                      value:
                                                                          '2',
                                                                      child:
                                                                          Text(
                                                                        'Report Order',
                                                                      ),
                                                                    ),
                                                                ];
                                                              },
                                                              onSelected: (String
                                                                  value) async {
                                                                if (value ==
                                                                    '0') {
                                                                  await userController
                                                                      .getDownload(
                                                                    orderId: data[
                                                                            index]
                                                                        [
                                                                        'order_id'],
                                                                  );
                                                                } else if (value ==
                                                                    '2') {
                                                                  Get.to(
                                                                    () =>
                                                                        RequestSupportPage(
                                                                      orderId: data[
                                                                              index]
                                                                          [
                                                                          'order_id'],
                                                                    ),
                                                                  );
                                                                } else {
                                                                  await showRatingDialog(
                                                                    freelancerName:
                                                                        data[index]
                                                                            [
                                                                            'name'],
                                                                    orderId: data[
                                                                            index]
                                                                        [
                                                                        'order_id'],
                                                                    freelancerId:
                                                                        data[index]['freelancer_id']
                                                                            .toString(),
                                                                    serviceId: data[index]
                                                                            [
                                                                            'service_id']
                                                                        .toString(),
                                                                    broadcast:
                                                                        'yes',
                                                                  );
                                                                }
                                                              },
                                                            )
                                                          : Container(),
                                                    ],
                                                  )
                                                : status == 'delivered'
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          CountdownTimer(
                                                            endTime:
                                                                parsedExpirationDate
                                                                    .millisecondsSinceEpoch,
                                                            widgetBuilder:
                                                                (context,
                                                                    time) {
                                                              if (time ==
                                                                  null) {
                                                                return Text(
                                                                  data[index][
                                                                      'updated_at'],
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                );
                                                              } else {
                                                                return Text(
                                                                  'Auto Complete in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          data[index]['fileCount'] ==
                                                                  1
                                                              ? PopupMenuButton(
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      if (data[index]
                                                                              [
                                                                              'fileCount'] ==
                                                                          1)
                                                                        const PopupMenuItem(
                                                                          value:
                                                                              '0',
                                                                          child:
                                                                              Text(
                                                                            'Download File',
                                                                          ),
                                                                        ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (String
                                                                          value) async {
                                                                    if (value ==
                                                                        '0') {
                                                                      await userController
                                                                          .getDownload(
                                                                        orderId:
                                                                            data[index]['order_id'],
                                                                      );
                                                                    }
                                                                  },
                                                                )
                                                              : Container(),
                                                        ],
                                                      )
                                                    : status == 'cancelled'
                                                        ? Text(data[index]
                                                            ['updated_at'])
                                                        : Container(),
                            const Divider(),
                            Row(
                              children: [
                                data[index]['servicePic'] == null
                                    ? SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.asset(
                                            'assets/images/blank_image.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.network(
                                            linkServicePic,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedPrice,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        data[index]['order_id'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        data[index]['type_name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        data[index]['service_name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (data[index]['address'] != null)
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.black,
                                      ),
                                  text: 'Meet Up Location: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.blue[600],
                                          ),
                                      text: data[index]['address'],
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          MapUtils.openMap(
                                            double.parse(data[index]['lat']),
                                            double.parse(data[index]['lng']),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await chatController.createChatRoom(
                                        UserData(
                                          userId: data[index]['freelancerId'],
                                          piclink: linkAvatar,
                                          name: data[index]['name'],
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        data[index]['servicePic'] != null
                                            ? SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(100),
                                                  child: Image.network(
                                                    linkAvatar,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(100),
                                                  child: Image.asset(
                                                    'assets/images/blank_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          data[index]['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Chip(
                                      label: Text("${data[index]['order_status']}"
                                          .capitalize!)),
                                ),
                              ],
                            ),
                            if (data[index]['order_status'] == 'delivered')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (data[index]['revision'] >= 0)
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.red),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                showRevisionDialog(
                                                    data[index]['order_id']);
                                              },
                                              child: const Text(
                                                "Revision",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await showRatingDialog(
                                          freelancerName: data[index]['name'],
                                          orderId: data[index]['order_id'],
                                          freelancerId: data[index]
                                                  ['freelancer_id']
                                              .toString(),
                                          serviceId: data[index]['service_id']
                                              .toString(),
                                          broadcast: 'no',
                                        ).then((value) async =>
                                            await userController.completeOrder(
                                              orderId: data[index]['order_id'],
                                            ));
                                      },
                                      child: const Text(
                                        "Complete",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Order Available'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
