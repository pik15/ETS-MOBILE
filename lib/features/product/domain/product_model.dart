class Product {
  final String id;
  final String name;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  // Factory untuk menangani berbagai format JSON API[cite: 2, 6]
  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    
    if (json['image'] != null) {
      // Format FakeStoreAPI[cite: 2, 6]
      imageUrl = json['image'].toString();
    } else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      // Format API lain dengan pembersihan karakter ilegal[cite: 2, 6]
      imageUrl = json['images'][0].toString();
      imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    }

    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Tanpa Nama', 
      image: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
    );
  }

  // METHOD KRITIS: copyWith untuk mendukung manipulasi data berbasis NIM
  Product copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}