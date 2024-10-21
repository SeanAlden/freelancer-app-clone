import 'package:flutter/material.dart';

class FAQListView extends StatefulWidget {
  const FAQListView({super.key});

  @override
  _FAQListViewState createState() => _FAQListViewState();
}

class _FAQListViewState extends State<FAQListView> {
  final List<Map<String, String>> faqData = [
    {
      'question': 'Bagaimana cara untuk mengakses seller mode?',
      'answer':
          'Menuju ke halaman profil, setelah itu menekan tombol seller mode. Jika sudah menekan tombol seller mode, lalu isikan data diri dengan mengikuti perintah pada tiap bagian.'
    },
    {
      'question':
          'Bagaimana cara untuk melakukan posting untuk layanan atau jasa pada aplikasi ini?',
      'answer':
          'Setelah mengubah mode akun menjadi seller mode, Anda dapat melakukan posting jasa / layanan dengan menekan tombol "Add New Services".'
    },
    {
      'question':
          'Jika telah melakukan pembelian pada suatu barang/jasa, namun belum melakukan pembayaran, apakah pembelian tersebut bisa otomatis di cancel secara realtime?',
      'answer':
          'Iya, pembelian tersebut akan secara otomatis dibatalkan secara langsung jika pembayaran tidak dilakukan atau terlambat dilakukan.'
    },
    {
      'question':
          'Apakah dapat melakukan refund dana jika sudah terlanjur melakukan pembayaran, namun melebihi deadline yang ditentukan sehingga pembelian tidak berhasil?',
      'answer': 'Fitur tersebut sedang dalam proses pengerjaan.'
    },
    {
      'question':
          'Bagaimana cara untuk melihat detail dari setiap list berita?',
      'answer':
          'Dengan menekan gambar berita yang dituju, maka Anda akan menuju pada halaman detail, dan Anda dapat membuka halaman web/url dengan menekan tombol "Read Full Article".'
    },
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
              hintText: 'Search FAQ',
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
