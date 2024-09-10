// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/pusher_controller.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:clone_freelancer_mobile/views/support/report_chat_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ListSupportTicket extends StatefulWidget {
  const ListSupportTicket({super.key});

  @override
  State<ListSupportTicket> createState() => _ListSupportTicketState();
}

class _ListSupportTicketState extends State<ListSupportTicket> {
  late Future futureListTicket;
  final UserController userController = Get.put(UserController());
  final box = GetStorage();
  final PusherService _pusherService = PusherService();

  @override
  void initState() {
    super.initState();
    fetchData();
    connect();
  }

  void onNewMessage(PusherEvent event) {
    fetchData();
  }

  void connect() {
    _pusherService.addEventListener('message.update', onNewMessage);
    _pusherService.connetToPusher(
        channelName: 'update.${box.read('user')['user_id']}');
  }

  void fetchData() async {
    print('Fetching data');
    setState(() {
      futureListTicket = userController.getListSupportTicket();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pusherService.disconnet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('My Support Request'),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureListTicket,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No support request available'),
              );
            } else {
              final data = snapshot.data;

              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DateTime dateTime =
                      DateTime.parse(data[index]['updated_at']).toLocal();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.to(
                        () => ReportChatPage(
                          reportId: data[index]['report_id'].toString(),
                          subject: data[index]['subject'],
                          status: data[index]['status'],
                        ),
                      )?.then((_) {
                        connect();
                        fetchData();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: ${data[index]['status']}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index]['subject'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          formattedDate,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    ),
                                    data[index]['lastMessage'] == null
                                        ? Text(
                                            data[index]['description'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade600,
                                                ),
                                          )
                                        : Text(
                                            data[index]['lastMessage'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade600,
                                                ),
                                          ),
                                  ],
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
            }
          },
        ),
      ),
    );
  }
}
