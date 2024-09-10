class Occupation {
  String occupation;
  String from;
  String to;

  Occupation({required this.occupation, required this.from, required this.to});

  // Convert Languages instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'occupation': occupation,
      'from': from,
      'to': to,
    };
  }
}
