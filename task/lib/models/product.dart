class Product {
  String name;
  String category;
  String state;
  String city;
  String company;

  Product({
    required this.name,
    required this.category,
    required this.state,
    required this.city,
    required this.company,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json["name"],
      category: json["category"],
      state: json["state"],
      city: json["city"],
      company: json["company"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
        "state": state,
        "city": city,
        "company": company,
      };
}
