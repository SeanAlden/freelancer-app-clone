import 'package:clone_freelancer_mobile/views/faq/contact_page.dart';
import 'package:clone_freelancer_mobile/views/faq/faq_list.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Helpdesk'),
          flexibleSpace: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            // ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FAQListView(),
            ContactListView(),
          ],
        ),
      ),
    );
  }
}