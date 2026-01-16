// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NewsDetailPage extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final String description;
//   final String publishedAt;
//   final String url;

//   NewsDetailPage({
//     required this.title,
//     required this.imageUrl,
//     required this.description,
//     required this.publishedAt,
//     required this.url,
//   });

//   // Function to launch the URL in the browser
//   Future<void> _launchURL() async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           color: Colors.white,
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: const Text(
//           'News Detail', // Judul AppBar
//           style: TextStyle(
//             color: Colors.white, // Ganti dengan warna yang diinginkan
//             fontSize: 20, // Ukuran teks bisa disesuaikan
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display the news image
//             Image.network(imageUrl, fit: BoxFit.cover),

//             SizedBox(height: 16.0),

//             // Display the news title
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             SizedBox(height: 8.0),

//             // Display the published date
//             Text(
//               'Published on: $publishedAt',
//               style: TextStyle(color: Colors.grey[600]),
//             ),

//             SizedBox(height: 16.0),

//             // Display the news description
//             Text(
//               description,
//               style: TextStyle(fontSize: 16.0),
//             ),

//             SizedBox(height: 24.0),

//             // Button to open the full article in the browser
//             Center(
//               // child: ElevatedButton(
//               //   onPressed: _launchURL, // Call the _launchURL function on press
//               //   child: Text('Read Full Article'),
//               // ),
//               child: ElevatedButton(
//                 onPressed:
//                     _launchURL, // Panggil fungsi _launchURL saat tombol ditekan
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 15), // Jarak dalam tombol
//                   backgroundColor: Colors.blueAccent, // Warna latar tombol
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(
//                         12), // Bentuk tombol dengan sudut melengkung
//                   ),
//                   shadowColor:
//                       Colors.black.withOpacity(0.5), // Warna bayangan tombol
//                   elevation: 5, // Tinggi bayangan
//                 ),
//                 child: Text(
//                   'Read Full Article',
//                   style: TextStyle(
//                     color: Colors.white, // Warna teks
//                     fontSize: 16, // Ukuran teks
//                     fontWeight: FontWeight.bold, // Ketebalan teks
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: Text(
          'title'.tr,
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ), // Translated text
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(imageUrl, fit: BoxFit.cover),

            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,

              // Saat loading
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 220,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },

              // Saat error / gambar tidak ditemukan
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/dummy.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                );
              },
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '${'published_on'.tr} $publishedAt', // Translated text
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: _launchURL,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black.withOpacity(0.5),
                  elevation: 5,
                ),
                child: Text(
                  'read_full_article'.tr, // Translated text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:url_launcher/url_launcher.dart';

// class NewsDetailPage extends StatefulWidget {
//   final String title;
//   final String description;
//   final String imageUrl;
//   final String publishedAt;
//   final String url;

//   NewsDetailPage({
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.publishedAt,
//     required this.url,
//   });

//   @override
//   _NewsDetailPageState createState() => _NewsDetailPageState();
// }

// class _NewsDetailPageState extends State<NewsDetailPage> {
//   late String translatedTitle;
//   late String translatedDescription;
//   bool isTranslating = true;

//   @override
//   void initState() {
//     super.initState();
//     _translateNewsContent();
//   }

//   Future<String> translateText(String text, String targetLang) async {
//   final url = Uri.parse('https://libretranslate.com/translate');
  
//   final response = await http.post(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//     },
//     body: json.encode({
//       'q': text,
//       'source': 'en',  // Source language, misalnya en (English)
//       'target': targetLang,
//     }),
//   );

//   if (response.statusCode == 200) {
//     final jsonResponse = json.decode(response.body);
//     return jsonResponse['translatedText'];
//   } else {
//     throw Exception('Failed to load translation');
//   }
// }

//   Future<void> _translateNewsContent() async {
//     try {
//       String currentLang = Get.locale!.languageCode;
//       translatedTitle = await translateText(widget.title, currentLang);
//       translatedDescription = await translateText(widget.description, currentLang);
//     } catch (e) {
//       translatedTitle = widget.title;
//       translatedDescription = widget.description;
//     } finally {
//       setState(() {
//         isTranslating = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('title'.tr),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: isTranslating
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.network(widget.imageUrl, fit: BoxFit.cover),
//                   SizedBox(height: 16.0),
//                   Text(
//                     translatedTitle,
//                     style: TextStyle(
//                       fontSize: 24.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     '${'published_on'.tr} ${widget.publishedAt}',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     translatedDescription,
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                   SizedBox(height: 24.0),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: _launchURL,
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         shadowColor: Colors.black.withOpacity(0.5),
//                         elevation: 5,
//                       ),
//                       child: Text(
//                         'read_full_article'.tr,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Future<void> _launchURL() async {
//     if (await canLaunch(widget.url)) {
//       await launch(widget.url);
//     } else {
//       throw 'Could not launch ${widget.url}';
//     }
//   }
// }

