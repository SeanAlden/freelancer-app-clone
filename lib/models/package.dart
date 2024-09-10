class Package {
  int? id;
  String title;
  String desc;
  int price;
  int deliveryDays;
  int revision;
  Package({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.deliveryDays,
    required this.revision,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'price': price,
      'deliveryDays': deliveryDays,
      'revision': revision,
    };
  }
}
