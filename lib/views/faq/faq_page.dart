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
          title: Text(
            'Helpdesk',
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: Container(
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              // ),
              ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact'),
            ],
            labelColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.yellowAccent[400] // Warna teks tab yang dipilih di mode gelap
                : Colors.yellowAccent[400], // Warna teks tab yang dipilih di mode terang
            unselectedLabelColor: Theme.of(context).brightness ==
                    Brightness.dark
                ? Colors.white // Warna teks tab yang tidak dipilih di mode gelap
                : Colors.white, // Warna teks tab yang tidak dipilih di mode terang
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // Warna indikator tab di mode gelap
                : Colors.black, // Warna indikator tab di mode terang
          ),
          // bottom: const TabBar(
          //   tabs: [
          //     Tab(text: 'FAQ'),
          //     Tab(text: 'Contact'),
          //   ],
          // ),
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
