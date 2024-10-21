import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final String publishedAt;
  final String url;

  NewsDetailPage({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.publishedAt,
    required this.url,
  });

  // Function to launch the URL in the browser
  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          'News Detail', // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the news image
            Image.network(imageUrl, fit: BoxFit.cover),

            SizedBox(height: 16.0),

            // Display the news title
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8.0),

            // Display the published date
            Text(
              'Published on: $publishedAt',
              style: TextStyle(color: Colors.grey[600]),
            ),

            SizedBox(height: 16.0),

            // Display the news description
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: 24.0),

            // Button to open the full article in the browser
            Center(
              // child: ElevatedButton(
              //   onPressed: _launchURL, // Call the _launchURL function on press
              //   child: Text('Read Full Article'),
              // ),
              child: ElevatedButton(
                onPressed:
                    _launchURL, // Panggil fungsi _launchURL saat tombol ditekan
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Jarak dalam tombol
                  backgroundColor: Colors.blueAccent, // Warna latar tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Bentuk tombol dengan sudut melengkung
                  ),
                  shadowColor:
                      Colors.black.withOpacity(0.5), // Warna bayangan tombol
                  elevation: 5, // Tinggi bayangan
                ),
                child: Text(
                  'Read Full Article',
                  style: TextStyle(
                    color: Colors.white, // Warna teks
                    fontSize: 16, // Ukuran teks
                    fontWeight: FontWeight.bold, // Ketebalan teks
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
