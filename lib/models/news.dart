class NewsArticle {
  final String title;
  final String? imageUrl;
  final String url;
  final String description; // Add description field
  final String publishedAt;  // Add publishedAt field

  // Constructor with required fields and optional fields for null handling
  NewsArticle({
    required this.title,
    this.imageUrl,
    required this.url,
    required this.description, // Required description
    required this.publishedAt,  // Required publishedAt
  });

  // Factory constructor to create an instance of NewsArticle from JSON
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title', // Default value for null title
      imageUrl: json['urlToImage'], // Default placeholder image for null image
      url: json['url'] ?? '', // Default empty string if no URL provided
      description: json['description'] ?? 'No description available.', // Default description
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(), // Default to current date/time if null
    );
  }
}

