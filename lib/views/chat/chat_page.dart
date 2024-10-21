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

// mendefinisikan class ChatPage yang merupakan StatefulWidget
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// mendefinisikan state untuk ChatPage
class _ChatPageState extends State<ChatPage> {
  // Inisialisasi controller chat dari GetX untuk mengelola chat
  final ChatController chatController = Get.put(ChatController());

  // Inisialisasi GetStorage untuk membaca data lokal pengguna
  final box = GetStorage();

  // Variabel future untuk menyimpan chat yang akan di-fetch
  late Future futureAllChat;

  // Inisialisasi service Pusher untuk real-time messaging
  final PusherService _pusherService = PusherService();

  // Fungsi untuk menangani event pesan baru
  void onNewMessage(PusherEvent event) {
    refreshData(); // Memuat ulang data ketika ada pesan baru
  }

  @override
  void initState() {
    super.initState();
    futureAllChat =
        chatController.fetchAllChat(); // Mem-fetch semua chat pada awal
    connect(); // Menghubungkan Pusher untuk mendengar pesan baru
  }

  // Fungsi untuk menghubungkan ke channel Pusher
  void connect() {
    _pusherService.addEventListener(
        'message.update', onNewMessage); // Menambahkan listener event
    _pusherService.connetToPusher(
        channelName:
            'update.${box.read('user')['user_id']}'); // Menghubungkan ke channel spesifik pengguna
  }

  // Fungsi untuk memuat ulang data chat dari server
  Future refreshData() async {
    setState(() {
      futureAllChat =
          chatController.fetchAllChat(); // Memanggil ulang fetchAllChat
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pusherService
        .disconnet(); // Memutuskan koneksi Pusher ketika widget dibuang
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Inbox", // Menampilkan judul di tengah AppBar
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      // FutureBuilder untuk menangani data yang akan datang
      body: FutureBuilder(
        future: futureAllChat, // Menampilkan future yang memuat semua chat
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Error: ${snapshot.error}'), // Jika ada error, tampilkan pesan error
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                  'No chat available'), // Jika tidak ada data, tampilkan pesan kosong
            );
          } else {
            final chatRoom =
                snapshot.data; // Data chat yang diterima dari snapshot
            return Container(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              // ListView untuk menampilkan daftar chat

              // child: SingleChildScrollView(
              //   scrollDirection:
              //       Axis.horizontal, // Mendukung scroll horizontal
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.vertical, // Mendukung scroll vertikal
              //     child: Column(
              //       children: [
              //         ListView.separated(
              //           shrinkWrap:
              //               true, // Gunakan true untuk membiarkan ListView mengukur ketinggiannya
              //           physics:
              //               NeverScrollableScrollPhysics(), // Nonaktifkan scroll internal ListView
              //           itemCount: chatRoom.length,
              //           separatorBuilder: (context, index) => const Divider(),
              //           itemBuilder: (context, index) {
              //             final item = chatRoom[index]['last_message'];
              //             UserData? user;
              //             UserData? otherUser;

              //             final participants =
              //                 chatRoom[index]['participants'];
              //             for (var participant in participants) {
              //               if (participant['user_id'] ==
              //                   box.read('user')['user_id']) {
              //                 user = UserData(
              //                     userId: participant['user']['user_id'],
              //                     piclink: participant['user']['piclink'],
              //                     name: participant['user']['name']);
              //               } else {
              //                 otherUser = UserData(
              //                     userId: participant['user']['user_id'],
              //                     piclink: participant['user']['piclink'],
              //                     name: participant['user']['name']);
              //               }
              //             }

              //             DateTime dateTime =
              //                 DateTime.parse(item['created_at']).toLocal();
              //             String formattedDate =
              //                 DateFormat('yyyy-MM-dd HH:mm:ss')
              //                     .format(dateTime);

              //             return GestureDetector(
              //               behavior: HitTestBehavior.opaque,
              //               onTap: () {
              //                 Get.to(
              //                   () => ChatDetailPage(
              //                     chatId: chatRoom[index]['chatRoom_id'],
              //                     userList: [user!, otherUser!],
              //                   ),
              //                 )?.then((_) {
              //                   connect();
              //                   refreshData();
              //                 });
              //               },
              //               child: ConversationList(
              //                 name: otherUser!.name,
              //                 messageText: item['message'] ?? '',
              //                 url: otherUser.piclink,
              //                 time: formattedDate,
              //                 chatId: chatRoom[index]['chatRoom_id'],
              //                 userList: [user!, otherUser],
              //               ),
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              child: ListView.separated(
                shrinkWrap: false,
                itemCount: chatRoom.length, // Jumlah item sesuai banyaknya chat
                separatorBuilder: (context, index) =>
                    const Divider(), // Pembatas antar item
                itemBuilder: (context, index) {
                  final item = chatRoom[index]
                      ['last_message']; // Mengambil pesan terakhir di chat room
                  UserData? user; // Variabel untuk user yang sedang login
                  UserData? otherUser; // Variabel untuk user lawan bicara

                  // Mengambil data partisipan dari setiap chat room
                  final participants = chatRoom[index]['participants'];
                  for (var participant in participants) {
                    if (participant['user_id'] == box.read('user')['user_id']) {
                      user = UserData(
                          userId: participant['user']['user_id'],
                          piclink: participant['user']['piclink'],
                          name: participant['user']
                              ['name']); // Menentukan user sebagai pengguna
                    } else {
                      otherUser = UserData(
                          userId: participant['user']['user_id'],
                          piclink: participant['user']['piclink'],
                          name: participant['user'][
                              'name']); // Menentukan otherUser sebagai lawan bicara
                    }
                  }

                  // Mengambil waktu pengiriman pesan terakhir dan memformatnya
                  DateTime dateTime =
                      DateTime.parse(item['created_at']).toLocal();
                  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                      .format(dateTime); // Format waktu pesan

                  // Mengelola gestur saat item chat diklik
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.to(
                        () => ChatDetailPage(
                          chatId: chatRoom[index][
                              'chatRoom_id'], // Kirim chatRoom_id ke halaman detail
                          userList: [
                            user!,
                            otherUser!
                          ], // Kirim data user dan otherUser
                        ),
                      )?.then((_) {
                        connect(); // Hubungkan kembali ke Pusher setelah kembali dari halaman detail
                        refreshData(); // Refresh data chat setelah kembali
                      });
                    },
                    child: ConversationList(
                      name: isPortrait
                          ? (otherUser!.name.length > 9
                              ? '${otherUser.name.substring(0, 9)}...' // Memotong nama jika lebih dari 9 karakter
                              : otherUser
                                  .name) // Menampilkan nama jika <= 9 karakter
                          : otherUser!
                              .name, // Menampilkan nama penuh di mode landscape
                      messageText: item['message'] ?? '', // Pesan terakhir
                      url: otherUser.piclink, // URL gambar profil lawan bicara
                      time: formattedDate, // Waktu pesan terakhir
                      chatId: chatRoom[index]['chatRoom_id'], // ID chat room
                      userList: [
                        user!,
                        otherUser
                      ], // Daftar pengguna dalam chat room
                    ),

                    // child: ConversationList(
                    //   name: otherUser!.name, // Nama lawan bicara
                    //   messageText: item['message'] ?? '', // Pesan terakhir
                    //   url: otherUser.piclink, // URL gambar profil lawan bicara
                    //   time: formattedDate, // Waktu pesan terakhir
                    //   chatId: chatRoom[index]['chatRoom_id'], // ID chat room
                    //   userList: [
                    //     user!,
                    //     otherUser
                    //   ], // Daftar pengguna dalam chat room
                    // ),
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
