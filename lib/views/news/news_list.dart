import 'dart:convert';

import 'package:clone_freelancer_mobile/models/news.dart';
import 'package:clone_freelancer_mobile/views/news/news_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pusher_channels_flutter/pusher-js/core/transports/url_schemes.dart';
import 'package:http/http.dart' as http;

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  late Future<List<NewsArticle>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  Future<List<NewsArticle>> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=freelancer&apiKey=16f57f8d0e444696863da47a233e651b'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['articles'];
      return jsonData.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'news'.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        FutureBuilder<List<NewsArticle>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final newsArticles = snapshot.data!;
              return Container(
                height: 250, // Adjust height as needed
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.99),
                  itemCount: newsArticles.length,
                  itemBuilder: (context, index) {
                    final article = newsArticles[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailPage(
                              title: article.title,
                              imageUrl: article.imageUrl,
                              description: article.description ??
                                  'no_desc'.tr,
                              publishedAt: article.publishedAt,
                              url: article.url,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 23),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  article.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.0),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 100,
                                right: 0,
                                child:
                                    // Container(
                                    //   padding: EdgeInsets.all(4),
                                    //   color: Colors
                                    //       .black54, // Semi-transparent background
                                    //   child: Text(
                                    //     article.title,
                                    //     style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 16,
                                    //     ),
                                    //     maxLines: 8,
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                    // ),
                                    Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .black54, // Semi-transparent background
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    article.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}