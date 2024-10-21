import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/views/support/support_request_page.dart';
import 'package:clone_freelancer_mobile/views/support/ticket_list_page.dart';
import 'package:get/get.dart';

class SupportListPage extends StatefulWidget {
  const SupportListPage({super.key});

  @override
  State<SupportListPage> createState() => _SupportListPageState();
}

class _SupportListPageState extends State<SupportListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Support', // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const ListSupportTicket());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 8,
                        ),
                        child: Icon(
                          Icons.password_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                      ),
                      Text("My Support Request"),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => const RequestSupportPage());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 8,
                        ),
                        child: Icon(
                          Icons.password_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                      ),
                      Text("Request Support"),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
