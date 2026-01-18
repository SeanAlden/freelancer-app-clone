// Mengabaikan peringatan lint untuk prefer_const_constructors
// Aturan lint prefer_const_constructors menyarankan penggunaan constructor konstan jika memungkinkan,
// tetapi diabaikan di sini.

// ignore_for_file: prefer_const_constructors

// Mengimpor paket Flutter Material untuk membangun komponen UI
import 'package:flutter/material.dart';
// Mengimpor ChatController khusus untuk mengelola logika terkait chat
import 'package:clone_freelancer_mobile/controllers/chat_controller.dart';
// Mengimpor model ChatUserData untuk menangani data pengguna
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
// Mengimpor paket GetX untuk manajemen state
import 'package:get/get.dart';

// Mendefiniskan StateFulWidget bernama ConversationList, yang mewakili setiap item percakapan dalam daftar
class ConversationList extends StatefulWidget {
  // Parameter yang diperlukan untuk setiap percakapan
  final String name; // nama dari partisipan chat  
  final String messageText; // teks pesan
  final String? url; // url gambar (opsional)
  final String time; // waktu dari pesan terkirim
  final int chatId; // id pesan
  final List<UserData> userList; // daftar user didalam chat

  // Constructor yang menginisialisasi widget ConversationList
  const ConversationList({
    super.key,
    required this.name, // tahun
    required this.messageText, // isi pesan
    required this.url, // url gambar (opsional)
    required this.time, // waktu pesan
    required this.chatId, // id chat
    required this.userList, // daftar user dari chat
  });

  // membuat state untuk daftar percakapan  
  @override
  State<ConversationList> createState() => _ConversationListState();
}

// mendefinisikan state class untuk widget list percakapan
class _ConversationListState extends State<ConversationList> {
  // menginisialisasi ChatController menggunakan dependency injection dari GetX 
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      // menambahkan padding di sekitar item percakapan
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // menyusun item secara vertikal di tengah 
        children: <Widget>[
          // jika url-nya tidak ada, maka akan menggunakan gambar kosong sebagai default untuk profile  
          widget.url == null
              ? const CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/blank_image.png', // path gambar
                  ),
                  maxRadius: 30, // size
                )
              : CircleAvatar(
                // gambar default digunakan saat gambar jaringan sedang default
                  backgroundImage: const AssetImage(
                    'assets/images/blank_image.png',
                  ),
                  // foto profil yang diambil dari jaringan
                  foregroundImage: NetworkImage(widget.url!),
                  maxRadius: 30, // ukuran lingkaran avatar
                ),
          SizedBox(
            width: 16, // ruang diantara gambar profil dan teks
          ),
          // Expanded memastikan kolom teks menggunakan sisa ruang yang tersedia 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Menyusun teks ke kiri
              children: [
                // Baris untuk menampilkan nama dan waktu dalam satu baris
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // nama di sebelah kiri, dan waktu di kanan
                  children: [
                    // Menampilkan nama peserta chat
                    Expanded(
                      child: Text(
                        widget.name,
                        style: Theme.of(context).textTheme.titleMedium, // Gaya sesuai tema 
                      ),
                    ),
                    // Menampilkan waktu pengiriman pesan
                    Expanded(
                      child: Text(
                        widget.time,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.normal, // Font Normal
                            ),
                      ),
                    ),
                  ],
                ),
                // Menampilkan teks pesan terbaru
                Text(
                  widget.messageText,
                  maxLines: 2, // Batas pesan yang maksimal 2 baris
                  overflow: TextOverflow.ellipsis, // Menambahkan elipsis (...) jika pesan terlalu panjang
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.normal, // Font normal
                        color: Colors.grey.shade600, // warna abu-abu
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
