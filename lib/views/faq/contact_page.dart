import 'package:flutter/material.dart';

class ContactListView extends StatefulWidget {
  const ContactListView({super.key});

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  final List<Map<String, dynamic>> contactData = [
    {
      'type': 'WhatsApp',
      'info': '+1234567890 (Freelancer Support)',
      'icon': 'assets/icons/whatsapp.png',
    },
    {
      'type': 'Email',
      'info': 'support@freelancer.com',
      'icon': 'assets/icons/email.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              // leading: Icon(
              //   // contactData[index]['icon'] as IconData,
              //   contactData[index]['icon'] as IconData?,
              //   color: Colors.blueAccent,
              //   size: 30,
              // ),
              leading: Image.asset(
                contactData[index]['icon']!,
                width: 24, // Set ukuran ikon sesuai kebutuhan
                height: 24,
              ),
              title: Text(
                contactData[index]['type'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                contactData[index]['info'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ),
          ),
        );
      },
    );
  }
}