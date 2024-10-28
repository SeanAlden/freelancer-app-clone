import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQListView extends StatefulWidget {
  const FAQListView({super.key});

  @override
  _FAQListViewState createState() => _FAQListViewState();
}

class _FAQListViewState extends State<FAQListView> {
  final List<Map<String, String>> faqData = [
    {'question': 'question_one'.tr, 'answer': 'answer_one'.tr},
    {'question': 'question_two'.tr, 'answer': 'answer_two'.tr},
    {'question': 'question_three'.tr, 'answer': 'answer_three'.tr},
    {'question': 'question_four'.tr, 'answer': 'answer_four'.tr},
    {'question': 'question_five'.tr, 'answer': 'answer_five'.tr},
    {'question': 'question_six'.tr, 'answer': 'answer_six'.tr},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFaq = faqData.where((faq) {
      return faq['question']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search_faq'.tr,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFaq.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      filteredFaq[index]['question'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // Warna teks untuk mode gelap
                            : Colors.black87, // Warna teks untuk mode terang
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          filteredFaq[index]['answer'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors
                                    .grey[400] // Warna teks untuk mode gelap
                                : Colors
                                    .grey[700], // Warna teks untuk mode terang
                          ),
                        ),
                      ),
                    ],
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
