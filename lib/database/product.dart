class Product {
  String id;
  String name;
  String description;
  int price;
  String image;
  String category;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'price': price,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? 'No Name',
      description: data['description'] ?? 'No Description',
      price: data['price'] ?? 0,
      image: data['image'] ?? 'No Image',
      category: data['category'] ?? 'No Category',
    );
  }
}