class Languages {
  String language;
  String level;

  Languages({required this.language, required this.level});

  // Convert Languages instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'level': level,
    };
  }
}
