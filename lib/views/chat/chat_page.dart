import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/chat_controller.dart';
import 'package:clone_freelancer_mobile/controllers/pusher_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/views/chat/chat_detail_page.dart';
import 'package:clone_freelancer_mobile/widgets/conversation_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController chatController = Get.put(ChatController());
  final box = GetStorage();
  late Future futureAllChat;
  final PusherService _pusherService = PusherService();

  void onNewMessage(PusherEvent event) {
    refreshData();
  }

  @override
  void initState() {
    super.initState();
    futureAllChat = chatController.fetchAllChat();
    connect();
  }

  void connect() {
    _pusherService.addEventListener('message.update', onNewMessage);
    _pusherService.connetToPusher(
        channelName: 'update.${box.read('user')['user_id']}');
  }

  Future refreshData() async {
    setState(() {
      futureAllChat = chatController.fetchAllChat();
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
          child: Text(
            "Inbox",
          ),
        ),
      ),
      body: FutureBuilder(
        future: futureAllChat,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chat available'),
            );
          } else {
            final chatRoom = snapshot.data;
            return Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: ListView.separated(
                shrinkWrap: false,
                itemCount: chatRoom.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = chatRoom[index]['last_message'];
                  UserData? user;
                  UserData? otherUser;
                  final participants = chatRoom[index]['participants'];
                  for (var participant in participants) {
                    if (participant['user_id'] == box.read('user')['user_id']) {
                      user = UserData(
                          userId: participant['user']['user_id'],
                          piclink: participant['user']['piclink'],
                          name: participant['user']['name']);
                    } else {
                      otherUser = UserData(
                          userId: participant['user']['user_id'],
                          piclink: participant['user']['piclink'],
                          name: participant['user']['name']);
                    }
                  }
                  DateTime dateTime =
                      DateTime.parse(item['created_at']).toLocal();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.to(
                        () => ChatDetailPage(
                          chatId: chatRoom[index]['chatRoom_id'],
                          userList: [user!, otherUser!],
                        ),
                      )?.then((_) {
                        connect();
                        refreshData();
                      });
                    },
                    child: ConversationList(
                      name: otherUser!.name,
                      messageText: item['message'] ?? '',
                      url: otherUser.piclink,
                      time: formattedDate,
                      chatId: chatRoom[index]['chatRoom_id'],
                      userList: [user!, otherUser],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
