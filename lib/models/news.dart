// class NewsArticle {
//   final String title;
//   final String imageUrl;
//   final String url;

//   NewsArticle({required this.title, required this.imageUrl, required this.url});

//   factory NewsArticle.fromJson(Map<String, dynamic> json) {
//     return NewsArticle(
//       title: json['title'],
//       imageUrl: json['urlToImage'],
//       url: json['url'],
//     );
//   }
// }

class NewsArticle {
  final String title;
  final String imageUrl;
  final String url;

  NewsArticle({
    required this.title,
    required this.imageUrl,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title', // Default value if null
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/150', // Default placeholder image
      url: json['url'] ?? '', // Default empty string
    );
  }
}
