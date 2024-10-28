import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ReportChatPage extends StatefulWidget {
  const ReportChatPage({
    super.key,
    required this.reportId,
    required this.subject,
    required this.status,
  });
  final String reportId;
  final String subject;
  final String status;

  @override
  State<ReportChatPage> createState() => _ReportChatPageState();
}

class _ReportChatPageState extends State<ReportChatPage> {
  late Future futureAllMessage;
  final box = GetStorage();
  final PusherService _pusherService = PusherService();
  final UserController userController = Get.put(UserController());
  final TextEditingController inputController = TextEditingController();

  void onNewMessage(PusherEvent event) {
    fetchData();
  }

  Future fetchData() async {
    setState(() {
      futureAllMessage =
          userController.fetchAllReportMessage(reportId: widget.reportId);
    });
  }

  void connect() {
    _pusherService.addEventListener('message.sent', onNewMessage);
    _pusherService.connetToPusher(channelName: 'report.${widget.reportId}');
  }

  @override
  void dispose() {
    super.dispose();
    _pusherService.disconnet();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // mengatur title page
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.subject, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  final data = snapshot.data;
                  return SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if (data[index]['user_id'] != null) {
                          return normalChatBubble(
                              data[index]['message'], index, true);
                        } else {
                          return normalChatBubble(
                              data[index]['message'], index, false);
                        }
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text('no_message'.tr),
                  );
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
                Expanded(
                  child: TextField(
                    enabled: widget.status == 'open' ? true : false,
                    controller: inputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                          top: 8.0,
                        ),
                        hintText: 'write_message'.tr,
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () async {
                    if (widget.status == 'open') {
                      if (inputController.text.trim().isNotEmpty) {
                        userController.sendReportMessage(
                          reportId: widget.reportId,
                          message: inputController.text.trim(),
                        );
                        inputController.clear();
                      }
                    }
                  },
                  backgroundColor: widget.status == 'open'
                      ? const Color(0xff6571ff)
                      : Colors.grey,
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

  Container normalChatBubble(message, int index, bool user) {
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
            message,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
