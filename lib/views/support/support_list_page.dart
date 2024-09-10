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
        title: const Center(
          child: Text('Support'),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const ListSupportTicket());
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
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
              decoration: const BoxDecoration(
                color: Colors.white,
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
