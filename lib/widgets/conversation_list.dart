// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/chat_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:get/get.dart';

class ConversationList extends StatefulWidget {
  final String name;
  final String messageText;
  final String? url;
  final String time;
  final int chatId;
  final List<UserData> userList;

  const ConversationList({
    super.key,
    required this.name,
    required this.messageText,
    required this.url,
    required this.time,
    required this.chatId,
    required this.userList,
  });

  @override
  State<ConversationList> createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.url == null
              ? const CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/blank_image.png',
                  ),
                  maxRadius: 30,
                )
              : CircleAvatar(
                  backgroundImage: const AssetImage(
                    'assets/images/blank_image.png',
                  ),
                  foregroundImage: NetworkImage(widget.url!),
                  maxRadius: 30,
                ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      widget.time,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
                Text(
                  widget.messageText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
