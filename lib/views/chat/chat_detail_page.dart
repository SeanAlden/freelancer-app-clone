// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/constant/globals.dart';
import 'package:clone_freelancer_mobile/controllers/chat_controller.dart';
import 'package:clone_freelancer_mobile/controllers/custom_order_controller.dart';
import 'package:clone_freelancer_mobile/controllers/payment_controller.dart';
import 'package:clone_freelancer_mobile/controllers/pusher_controller.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/views/chat/custom_order_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatDetailPage extends StatefulWidget {
  final int chatId;
  final List<UserData> userList;
  const ChatDetailPage(
      {super.key, required this.chatId, required this.userList});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ChatController chatController = Get.put(ChatController());
  final PaymentController paymentController = Get.put(PaymentController());
  ModeController modeController = Get.find<ModeController>();
  final CustomOrderController customOrderController =
      Get.put(CustomOrderController());
  final box = GetStorage();
  late Future futureAllMessage;
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final PusherService _pusherService = PusherService();
  final UserController userController = Get.put(UserController());
  bool isLoading = false;

  void onNewMessage(PusherEvent event) {
    refreshData();
  }

  @override
  void initState() {
    super.initState();
    futureAllMessage = chatController.fetchAllMessage(widget.chatId);
    connect();
  }

  void connect() {
    _pusherService.addEventListener('message.sent', onNewMessage);
    _pusherService.connetToPusher(channelName: 'chat.${widget.chatId}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshData() async {
    setState(() {
      futureAllMessage = chatController.fetchAllMessage(widget.chatId);
    });
  }

  void openCustomOrderDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => CustomOrderDialog(
        chatId: widget.chatId,
        onClose: (result) {
          Navigator.pop(context, result);
        },
      ),
    );

    if (result != null) {
      connect();
    }
  }

  Future payWithBalance({
    required int itemId,
    required int price,
    required int freelancerId,
  }) async {
    try {
      var data = {
        'type': 'custom',
        'itemId': itemId.toString(),
        'freelancer_id': freelancerId.toString(),
        'price': price.toString(),
      };

      var response = await http.post(
        Uri.parse('${url}balance/payment'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
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

  Future showPaymentOptions(
      {required int customId,
      required int serviceId,
      required String price,
      required int freelancerId,
      required}) async {
    final temp = await userController.getBalance();
    int balance = temp['balance'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Balance : ${balance.toString()}'),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (balance < int.parse(price)) {
                Get.snackbar(
                  "Error",
                  'balance_status'.tr,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                await payWithBalance(
                  itemId: customId,
                  price: int.parse(price),
                  freelancerId: freelancerId,
                ).then((value) => setState(() {
                      isLoading = false;
                    }));
                Navigator.of(context).pop();
              }
              setState(() {
                isLoading = false;
              });
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Payment Gateway'),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await paymentController
                  .getTokenForCustomOrder(
                    customId: customId,
                    serviceId: serviceId,
                    price: price,
                    freelancerId: freelancerId,
                  )   
                  .then((value) => setState(() {
                        isLoading = false;
                      }));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'withdrawn':
        return Colors.grey;
      case 'accepted':
        return Colors.blue;
      case 'rejected':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'active':
        return 'The custom offer is currently active.';
      case 'withdrawn':
        return 'The custom offer has been cancelled or withdrawn by the freelancer.';
      case 'accepted':
        return 'The custom offer has been accepted.';
      case 'rejected':
        return 'The custom offer has been rejected.';
      case 'expired':
        return 'Offer has expired.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            widget.userList[1].piclink == null
                ? const CircleAvatar(
                    foregroundImage: AssetImage(
                      'assets/images/blank_image.png',
                    ),
                  )
                : CircleAvatar(
                    foregroundImage: NetworkImage(
                      widget.userList[1].piclink.toString(),
                    ),
                    backgroundImage: const AssetImage(
                      'assets/images/blank_image.png',
                    ),
                  ),
            const SizedBox(
              width: 16,
            ),
            // Text(widget.userList[1].name),
            Text(
              MediaQuery.of(context).orientation == Orientation.portrait
                  // Jika orientasi potret dan panjang nama lebih dari 10 karakter, potong nama
                  ? (widget.userList[1].name.length > 10
                      ? '${widget.userList[1].name.substring(0, 10)}...' // Memotong karakter ke-11 dan menambahkan "..."
                      : widget.userList[1]
                          .name) // Tampilkan nama jika kurang dari atau sama dengan 10 karakter
                  : widget.userList[1]
                      .name, // Tampilkan nama lengkap di mode landscape
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white // Warna teks untuk mode gelap
                    : Colors.white, // Warna teks untuk mode terang
              ),
            ),

            // Text(
            //   MediaQuery.of(context).orientation == Orientation.portrait
            //       // Jika orientasi potret dan panjang nama lebih dari 10 karakter, potong nama
            //       ? (widget.userList[1].name.length > 10
            //           ? '${widget.userList[1].name.substring(0, 10)}...' // Memotong karakter ke-11 dan menambahkan "..."
            //           : widget.userList[1]
            //               .name) // Tampilkan nama jika kurang dari atau sama dengan 10 karakter
            //       : widget.userList[1]
            //           .name, // Tampilkan nama lengkap di mode landscape
            // ),
          ],
        ),
        actions: [
          box.read('user')['profile_type'] == 'freelancer' &&
                  modeController.mode.value
              ? PopupMenuButton(itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('create_custom_order'.tr),
                    ),
                  ];
                }, onSelected: (value) {
                  if (value == 0) {
                    openCustomOrderDialog(context);
                  }
                })
              : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: futureAllMessage,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  final allMessage = snapshot.data;
                  return SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: allMessage.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        if (allMessage[index]['user_id'] ==
                            box.read('user')['user_id']) {
                          if (allMessage[index]['service_id'] != null) {
                            var linkServicePic =
                                allMessage[index]['servicePic']['picasset'];
                            linkServicePic =
                                url.replaceFirst('/api/', '') + linkServicePic;
                            return chatBubbleRequest(context, linkServicePic,
                                allMessage, index, true);
                          } else if (allMessage[index]['custom_id'] != null) {
                            var data = allMessage[index]['custom_data'];
                            MoneyFormatter fmf = MoneyFormatter(
                                    amount:
                                        double.parse(data['price'].toString()))
                                .copyWith(symbol: 'IDR');

                            return customChatBubble(
                                data, context, fmf, allMessage, index, true);
                          } else {
                            return normalChatBubble(allMessage, index, true);
                          }
                        } else {
                          if (allMessage[index]['service_id'] != null) {
                            var linkServicePic =
                                allMessage[index]['servicePic']['picasset'];
                            linkServicePic =
                                url.replaceFirst('/api/', '') + linkServicePic;
                            return chatBubbleRequest(context, linkServicePic,
                                allMessage, index, false);
                          } else if (allMessage[index]['custom_id'] != null) {
                            var data = allMessage[index]['custom_data'];
                            MoneyFormatter fmf = MoneyFormatter(
                                    amount:
                                        double.parse(data['price'].toString()))
                                .copyWith(symbol: 'IDR');
                            return customChatBubble(
                                data, context, fmf, allMessage, index, false);
                          } else {
                            return normalChatBubble(allMessage, index, false);
                          }
                        }
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     height: 30,
                //     width: 30,
                //     decoration: BoxDecoration(
                //       color: const Color(0xff6571ff),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: const Icon(
                //       Icons.add,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   width: 15,
                // ),
                Expanded(
                  child: TextField(
                    controller: inputController,
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black),
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 8.0,
                        bottom: 8.0,
                        top: 8.0,
                      ),
                      hintText: 'write_message'.tr,
                      hintStyle: TextStyle(color:Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.black45),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    if (inputController.text.trim().isNotEmpty) {
                      chatController.sendMessage(
                          widget.chatId, inputController.text.trim());
                      inputController.clear();
                    }
                  },
                  backgroundColor: const Color(0xff6571ff),
                  elevation: 0,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container chatBubbleRequest(
      BuildContext context, linkServicePic, allMessage, int index, bool user) {
    return Container(
      padding: user == true
          ? const EdgeInsets.only(left: 64, right: 14, top: 4, bottom: 4)
          : const EdgeInsets.only(left: 14, right: 64, top: 4, bottom: 4),
      child: Align(
        alignment: user == true ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                user == true ? const Color(0xffa2a9ff) : Colors.grey.shade200,
          ),
          padding: user == true
              ? const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16)
              : const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'custom_order_request'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print('object');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      linkServicePic,
                      fit: BoxFit.cover,
                      height: 75,
                      width: 75,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        allMessage[index]['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                allMessage[index]['message'],
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container normalChatBubble(allMessage, int index, bool user) {
    return Container(
      padding: user != true
          ? const EdgeInsets.only(left: 14, right: 64, top: 4, bottom: 4)
          : const EdgeInsets.only(left: 64, right: 14, top: 4, bottom: 4),
      child: Align(
        alignment: user != true ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                user != true ? Colors.grey.shade400 : const Color(0xffa2a9ff),
          ),
          padding: user != true
              ? const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16)
              : const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: Text(
            allMessage[index]['message'],
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Container customChatBubble(
    data,
    BuildContext context,
    MoneyFormatter fmf,
    allMessage,
    int index,
    bool user,
  ) {
    DateTime parsedExpirationDate = DateTime.now();
    bool isExpired = false;
    if (data['expiration_date'] != null) {
      parsedExpirationDate = DateTime.parse(data['expiration_date']);
      isExpired = parsedExpirationDate.isBefore(DateTime.now());
    }
    return Container(
      padding: user == true
          ? const EdgeInsets.only(left: 64, right: 14, top: 4, bottom: 4)
          : const EdgeInsets.only(left: 14, right: 64, top: 4, bottom: 4),
      child: Align(
        alignment: user == true ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color:
                user != true ? Colors.grey.shade400 : const Color(0xffa2a9ff),
          ),
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data['status'] == 'pending'
                  ? isExpired
                      ? CountdownTimer(
                          endTime: parsedExpirationDate.millisecondsSinceEpoch,
                          widgetBuilder: (context, time) {
                            if (time == null) {
                              return Text(
                                'offer_has_expired'.tr,
                                style: TextStyle(color: Colors.red),
                              );
                            }
                            return Container();
                          },
                        )
                      : data['expiration_date'] == null
                          ? Container()
                          : CountdownTimer(
                              endTime:
                                  parsedExpirationDate.millisecondsSinceEpoch,
                              textStyle: const TextStyle(color: Colors.yellow),
                              widgetBuilder: (context, time) {
                                if (time != null) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'offer_expired_in'.tr,
                                        style: TextStyle(color: Colors.yellow),
                                      ),
                                      Text(
                                        '${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                            color: Colors.yellow),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text(
                                    'offer_has_expired'.tr,
                                    style: TextStyle(color: Colors.red),
                                  );
                                }
                              },
                            )
                  : Text(
                      _getStatusDescription(data['status']),
                      style: TextStyle(
                        color: _getStatusColor(
                          data['status'],
                        ),
                      ),
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'your_custom_order'.tr,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        fmf.output.compactSymbolOnLeft,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    allMessage[index]['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    data['description'],
                  ),
                  const Divider(),
                  Text(
                    'offer_include'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${data['revision'].toString()} Revision",
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${data['delivery_days'].toString()} Day Delivery",
                      ),
                    ],
                  ),
                  if (data['onsite_date'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Appointment date: ${data['onsite_date']}'),
                        Text('Location: ${data['address']}'),
                      ],
                    )
                ],
              ),
              data['status'] == 'pending' && !isExpired
                  ? user == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Divider(),
                            ElevatedButton(
                              onPressed: () async {
                                await customOrderController
                                    .setCustomOrderStatus(
                                  customId: data['custom_id'].toString(),
                                  status: 'withdrawn',
                                  chatRoomId: widget.chatId.toString(),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(
                                        color: Color(0xff6571ff)),
                                  ),
                                ),
                              ),
                              child: Text(
                                'withdraw_custom_order'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: const Color(0xff6571ff),
                                    ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await showPaymentOptions(
                                      customId: data['custom_id'],
                                      serviceId: data['service_id'],
                                      price: data['price'],
                                      freelancerId: data['freelancer_id'],
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: const BorderSide(
                                            color: Color(0xff6571ff)),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'accept'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: const Color(0xff6571ff),
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await customOrderController
                                        .setCustomOrderStatus(
                                      customId: data['custom_id'].toString(),
                                      status: 'rejected',
                                      chatRoomId: widget.chatId.toString(),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: const BorderSide(
                                            color: Color(0xff6571ff)),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'reject'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: const Color(0xff6571ff),
                                        ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
