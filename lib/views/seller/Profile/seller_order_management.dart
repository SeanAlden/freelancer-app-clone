import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:clone_freelancer_mobile/controllers/chat_controller.dart';
import 'package:clone_freelancer_mobile/controllers/pusher_controller.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/launch_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class SellerOrderPage extends StatefulWidget {
  const SellerOrderPage({super.key});

  @override
  State<SellerOrderPage> createState() => _SellerOrderPageState();
}

class _SellerOrderPageState extends State<SellerOrderPage> {
  late Future futureListOrder;
  String status = 'all';
  final box = GetStorage();
  final SellerController sellerController = Get.put(SellerController());
  final ChatController chatController = Get.put(ChatController());
  final PusherService _pusherService = PusherService();
  TextEditingController responseController = TextEditingController();
  File? _file;
  final _formKey = GlobalKey<FormState>();

  TextEditingController descController = TextEditingController();

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

  void fetchData() async {
    setState(() {
      futureListOrder = sellerController.getAllOrder(status: status);
    });
  }

  void connect() {
    _pusherService.addEventListener('manage.update', onNewMessage);
    _pusherService.connetToPusher(
        channelName: 'update.${box.read('user')['user_id']}');
  }

  Future showRevisionReject(String orderId) async {
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
                      controller: responseController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Type your response here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Describe the changes you\'d like';
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
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await sellerController.requestConfirmation(
                  orderId: orderId,
                  status: 'reject',
                  respon: responseController.text.trim(),
                );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Yes'),
          ),
        ],
        title: const Text('Revision Details'),
      ),
    ).then((value) {
      responseController.clear();
    });
  }

  void openDialogRevision(BuildContext context, String desc) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Revision Notes', style: textTheme.titleLarge!),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(desc, style: textTheme.titleSmall!),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: textTheme.labelLarge!),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void openDialog(BuildContext context, String title, String desc, int revision,
      int deliveryDays) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: textTheme.titleLarge!),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Revision : $revision',
                  style:
                      textTheme.titleSmall!.copyWith(color: Colors.grey[600])),
              Text('Delivery Days : $deliveryDays',
                  style:
                      textTheme.titleSmall!.copyWith(color: Colors.grey[600])),
              const SizedBox(
                height: 8,
              ),
              Text(desc, style: textTheme.titleSmall!),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: textTheme.labelLarge!),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future showDialogWithFile(String orderId) async {
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
                      controller: descController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe your delivery...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xffa2a9ff)),
                      ),
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          setState(() {
                            _file = File(result.files.single.path!);
                          });
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attach_file_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Upload File',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    _file == null
                        ? const Text('No File Selected !')
                        : Text(_file!.path)
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              descController.clear();
              _file = null;
              Navigator.of(dialogContext).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _file != null) {
                await sellerController
                    .deliverNow(
                      fileUrl: _file?.path ?? '',
                      orderId: orderId,
                      desc: descController.text.trim(),
                    )
                    .then((value) => Navigator.of(dialogContext).pop());
              } else {
                Get.snackbar(
                  "Error",
                  'Please attach file',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Yes'),
          ),
        ],
        title: const Text('Deliver Order ?'),
      ),
    ).then((value) {
      descController.clear();
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'manage_order'.tr, // Judul AppBar
            style: TextStyle(
              color: Colors.white, // Ganti dengan warna yang diinginkan
              fontSize: 20, // Ukuran teks bisa disesuaikan
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
                    status = 'pending';
                  });
                  break;
                case 2:
                  setState(() {
                    status = 'in progress';
                  });
                  break;
                case 3:
                  setState(() {
                    status = 'delivered';
                  });
                  break;
                case 4:
                  setState(() {
                    status = 'revision requested';
                  });
                  break;
                case 5:
                  setState(() {
                    status = 'completed';
                  });
                  break;
                case 6:
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
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: futureListOrder,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null || snapshot.data.isEmpty) {
                return Center(child: Text('no_order'.tr));
              } else if (snapshot.data['package'].length == 0 &&
                  snapshot.data['custom'].length == 0) {
                return Center(child: Text('no_order'.tr));
              } else {
                final data = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data['package'].length > 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Standard Order'),
                                const SizedBox(
                                  height: 8,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    MoneyFormatter fmf = MoneyFormatter(
                                            amount: double.parse(data['package']
                                                    [index]['price']
                                                .toString()))
                                        .copyWith(symbol: 'IDR');
                                    DateTime parsedExpirationDate =
                                        DateTime.now();
                                    if (data['package'][index]['due_date'] !=
                                        null) {
                                      parsedExpirationDate = DateTime.parse(
                                          data['package'][index]['due_date']);
                                    }
                                    var status =
                                        data['package'][index]['order_status'];
                                    print(data['package'][index]);
                                    return Card(
                                      elevation: 5,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            status == 'pending'
                                                ? CountdownTimer(
                                                    endTime: parsedExpirationDate
                                                        .millisecondsSinceEpoch,
                                                    widgetBuilder:
                                                        (context, time) {
                                                      if (time == null) {
                                                        return const Text(
                                                          'Order has cancelled',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        );
                                                      } else {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}'),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  )
                                                : status == 'in progress'
                                                    ? CountdownTimer(
                                                        endTime:
                                                            parsedExpirationDate
                                                                .millisecondsSinceEpoch,
                                                        widgetBuilder:
                                                            (context, time) {
                                                          if (time == null) {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  'Late',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                PopupMenuButton(
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      const PopupMenuItem(
                                                                        value:
                                                                            '0',
                                                                        child:
                                                                            Text(
                                                                          'Deliver Now',
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (String
                                                                          value) {
                                                                    if (value ==
                                                                        '0') {
                                                                      showDialogWithFile(data['package']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'order_id']);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}'),
                                                                PopupMenuButton(
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      const PopupMenuItem(
                                                                        value:
                                                                            '0',
                                                                        child:
                                                                            Text(
                                                                          'Deliver Now',
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (String
                                                                          value) {
                                                                    if (value ==
                                                                        '0') {
                                                                      showDialogWithFile(data['package']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'order_id']);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      )
                                                    : status == 'delivered'
                                                        ? CountdownTimer(
                                                            endTime:
                                                                parsedExpirationDate
                                                                    .millisecondsSinceEpoch,
                                                            widgetBuilder:
                                                                (context,
                                                                    time) {
                                                              if (time ==
                                                                  null) {
                                                                return Text(
                                                                  data['package']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'updated_at'],
                                                                );
                                                              } else {
                                                                return Text(
                                                                    'Auto Complete in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}');
                                                              }
                                                            },
                                                          )
                                                        : status ==
                                                                'revision requested'
                                                            ? CountdownTimer(
                                                                endTime:
                                                                    parsedExpirationDate
                                                                        .millisecondsSinceEpoch,
                                                                widgetBuilder:
                                                                    (context,
                                                                        time) {
                                                                  if (time ==
                                                                      null) {
                                                                    return const Text(
                                                                      'Late',
                                                                    );
                                                                  } else {
                                                                    return Text(
                                                                        'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}');
                                                                  }
                                                                },
                                                              )
                                                            : Text(data['package']
                                                                    [index]
                                                                ['updated_at']),
                                            const Divider(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  fmf.output.symbolOnLeft,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  data['package'][index]
                                                      ['service_name'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Order Id: ${data['package'][index]['order_id']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                    text: 'Type: ',
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                final tempData =
                                                                    data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'data'];
                                                                openDialog(
                                                                  context,
                                                                  tempData[
                                                                      'title'],
                                                                  tempData[
                                                                      'description'],
                                                                  tempData[
                                                                      'revision'],
                                                                  tempData[
                                                                      'delivery_days'],
                                                                );
                                                              },
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .blue[600],
                                                            ),
                                                        text: data['package']
                                                                [index]
                                                            ['type_name'],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                    text: 'Client: ',
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .blue[600],
                                                            ),
                                                        text: data['package']
                                                            [index]['name'],
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                await chatController
                                                                    .createChatRoom(
                                                                  UserData(
                                                                    userId: data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'client_id'],
                                                                    piclink: data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'piclink'],
                                                                    name: data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                  ),
                                                                );
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (data['package'][index]
                                                        ['address'] !=
                                                    null)
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      text: 'Location: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                          text: data['package']
                                                                  [index]
                                                              ['address'],
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  MapUtils
                                                                      .openMap(
                                                                    double.parse(data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'lat']),
                                                                    double.parse(data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'lng']),
                                                                  );
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (status ==
                                                    'revision requested')
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      text: 'Revision ID: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                          text: data['package'][
                                                                          index]
                                                                      [
                                                                      'revData']
                                                                  [
                                                                  'revision_id']
                                                              .toString(),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  openDialogRevision(
                                                                    context,
                                                                    data['package'][index]
                                                                            [
                                                                            'revData']
                                                                        [
                                                                        'notes'],
                                                                  );
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (status == 'in progress' &&
                                                    data['package'][index]
                                                            ['revData'] !=
                                                        null)
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      text: 'Revision ID: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                          text: data['package'][
                                                                          index]
                                                                      [
                                                                      'revData']
                                                                  [
                                                                  'revision_id']
                                                              .toString(),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  openDialogRevision(
                                                                    context,
                                                                    data['package'][index]
                                                                            [
                                                                            'revData']
                                                                        [
                                                                        'notes'],
                                                                  );
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            status == 'pending'
                                                ? CountdownTimer(
                                                    endTime: parsedExpirationDate
                                                        .millisecondsSinceEpoch,
                                                    widgetBuilder:
                                                        (context, time) {
                                                      if (time != null) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .red),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await sellerController
                                                                      .orderConfirmation(
                                                                    status:
                                                                        'decline',
                                                                    orderId: data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'order_id'],
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Decline",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .green),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await sellerController
                                                                      .orderConfirmation(
                                                                    status:
                                                                        'accept',
                                                                    orderId: data['package']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'order_id'],
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Accept",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  )
                                                : status == 'revision requested'
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .red),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                showRevisionReject(
                                                                  data['package']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'order_id'],
                                                                );
                                                              },
                                                              child: const Text(
                                                                "Reject",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .green),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                await sellerController
                                                                    .requestConfirmation(
                                                                  orderId: data[
                                                                              'package']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'order_id'],
                                                                  status:
                                                                      'accept',
                                                                  respon: '',
                                                                );
                                                              },
                                                              child: const Text(
                                                                "Accept",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Chip(
                                                            label: Text(
                                                                "${data['package'][index]['order_status']}"
                                                                    .capitalize!)),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: data['package'].length,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            )
                          : Container(),
                      data['custom'].length > 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Customized Order'),
                                const SizedBox(
                                  height: 8,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    MoneyFormatter fmf = MoneyFormatter(
                                            amount: double.parse(data['custom']
                                                    [index]['price']
                                                .toString()))
                                        .copyWith(symbol: 'IDR');
                                    DateTime parsedExpirationDate =
                                        DateTime.now();
                                    if (data['custom'][index]['due_date'] !=
                                        null) {
                                      parsedExpirationDate = DateTime.parse(
                                          data['custom'][index]['due_date']);
                                    }
                                    var status =
                                        data['custom'][index]['order_status'];
                                    return Card(
                                      elevation: 5,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            status == 'pending'
                                                ? CountdownTimer(
                                                    endTime: parsedExpirationDate
                                                        .millisecondsSinceEpoch,
                                                    widgetBuilder:
                                                        (context, time) {
                                                      if (time == null) {
                                                        return const Text(
                                                          'Order has cancelled',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        );
                                                      } else {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}'),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  )
                                                : status == 'in progress'
                                                    ? CountdownTimer(
                                                        endTime:
                                                            parsedExpirationDate
                                                                .millisecondsSinceEpoch,
                                                        widgetBuilder:
                                                            (context, time) {
                                                          if (time == null) {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  'Late',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                PopupMenuButton(
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      const PopupMenuItem(
                                                                        value:
                                                                            '0',
                                                                        child:
                                                                            Text(
                                                                          'Deliver Now',
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (String
                                                                          value) {
                                                                    if (value ==
                                                                        '0') {
                                                                      showDialogWithFile(data['custom']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'order_id']);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}'),
                                                                PopupMenuButton(
                                                                  itemBuilder:
                                                                      (context) {
                                                                    return [
                                                                      const PopupMenuItem(
                                                                        value:
                                                                            '0',
                                                                        child:
                                                                            Text(
                                                                          'Deliver Now',
                                                                        ),
                                                                      ),
                                                                    ];
                                                                  },
                                                                  onSelected:
                                                                      (String
                                                                          value) {
                                                                    if (value ==
                                                                        '0') {
                                                                      showDialogWithFile(data['custom']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'order_id']);
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      )
                                                    : status == 'delivered'
                                                        ? CountdownTimer(
                                                            endTime:
                                                                parsedExpirationDate
                                                                    .millisecondsSinceEpoch,
                                                            widgetBuilder:
                                                                (context,
                                                                    time) {
                                                              if (time ==
                                                                  null) {
                                                                return Text(
                                                                  data['custom']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'updated_at'],
                                                                );
                                                              } else {
                                                                return Text(
                                                                    'Auto Complete in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}');
                                                              }
                                                            },
                                                          )
                                                        : status ==
                                                                'revision requested'
                                                            ? CountdownTimer(
                                                                endTime:
                                                                    parsedExpirationDate
                                                                        .millisecondsSinceEpoch,
                                                                widgetBuilder:
                                                                    (context,
                                                                        time) {
                                                                  if (time ==
                                                                      null) {
                                                                    return const Text(
                                                                      'Late',
                                                                    );
                                                                  } else {
                                                                    return Text(
                                                                        'Due in ${time.days != null ? '${time.days} days ' : ''}${(time.hours ?? 0).toString().padLeft(2, '0')}:${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}');
                                                                  }
                                                                },
                                                              )
                                                            : Text(data['custom']
                                                                    [index]
                                                                ['updated_at']),
                                            const Divider(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  fmf.output.symbolOnLeft,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  data['custom'][index]
                                                      ['service_name'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Order Id: ${data['custom'][index]['order_id']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                    text: 'Type: ',
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap =
                                                                  () async {
                                                                final tempData =
                                                                    data['custom']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'data'];
                                                                openDialog(
                                                                  context,
                                                                  'Custom Order',
                                                                  tempData[
                                                                      'description'],
                                                                  tempData[
                                                                      'revision'],
                                                                  tempData[
                                                                      'delivery_days'],
                                                                );
                                                              },
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .blue[600],
                                                            ),
                                                        text: data['custom']
                                                                [index]
                                                            ['type_name'],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                      text: 'Client: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: data['custom']
                                                              [index]['name'],
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                  color: Colors
                                                                          .blue[
                                                                      600]),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  await chatController
                                                                      .createChatRoom(
                                                                    UserData(
                                                                      userId: data['custom']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'client_id'],
                                                                      piclink: data['custom']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'piclink'],
                                                                      name: data['custom']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                    ),
                                                                  );
                                                                },
                                                        ),
                                                      ]),
                                                ),
                                                if (data['custom'][index]
                                                        ['address'] !=
                                                    null)
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      text: 'Location: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                          text: data['custom']
                                                                  [index]
                                                              ['address'],
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  MapUtils
                                                                      .openMap(
                                                                    double.parse(data['custom']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'lat']),
                                                                    double.parse(data['custom']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'lng']),
                                                                  );
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (status ==
                                                    'revision requested')
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      text: 'Revision ID: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                          text: data['custom'][
                                                                          index]
                                                                      [
                                                                      'revData']
                                                                  [
                                                                  'revision_id']
                                                              .toString(),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  openDialogRevision(
                                                                    context,
                                                                    data['custom'][index]
                                                                            [
                                                                            'revData']
                                                                        [
                                                                        'notes'],
                                                                  );
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (status == 'in progress' &&
                                                    data['custom'][index]
                                                            ['revData'] !=
                                                        null)
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      text: 'Revision ID: ',
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleSmall
                                                              ?.copyWith(
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                          text: data['custom'][
                                                                          index]
                                                                      [
                                                                      'revData']
                                                                  [
                                                                  'revision_id']
                                                              .toString(),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap =
                                                                    () async {
                                                                  openDialogRevision(
                                                                    context,
                                                                    data['custom'][index]
                                                                            [
                                                                            'revData']
                                                                        [
                                                                        'notes'],
                                                                  );
                                                                },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            status == 'pending'
                                                ? CountdownTimer(
                                                    endTime: parsedExpirationDate
                                                        .millisecondsSinceEpoch,
                                                    widgetBuilder:
                                                        (context, time) {
                                                      if (time != null) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .red),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await sellerController
                                                                      .orderConfirmation(
                                                                    status:
                                                                        'decline',
                                                                    orderId: data['custom']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'order_id'],
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Decline",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .green),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  await sellerController
                                                                      .orderConfirmation(
                                                                    status:
                                                                        'accept',
                                                                    orderId: data['custom']
                                                                            [
                                                                            index]
                                                                        [
                                                                        'order_id'],
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Accept",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  )
                                                : status == 'revision requested'
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .red),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                showRevisionReject(
                                                                  data['custom']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'order_id'],
                                                                );
                                                              },
                                                              child: const Text(
                                                                "Reject",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .green),
                                                                shape: MaterialStateProperty
                                                                    .all<
                                                                        RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                await sellerController
                                                                    .requestConfirmation(
                                                                  orderId: data[
                                                                              'custom']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'order_id'],
                                                                  status:
                                                                      'accept',
                                                                  respon: '',
                                                                );
                                                              },
                                                              child: const Text(
                                                                "Accept",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Chip(
                                                            label: Text(
                                                                "${data['custom'][index]['order_status']}"
                                                                    .capitalize!)),
                                                      ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: data['custom'].length,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
