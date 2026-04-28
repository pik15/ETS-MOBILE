class Product {
  final String id;
  final String name;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Logika pembersihan URL gambar agar tidak error di UI
    String imageUrl = '';
    
    if (json['image'] != null) {
      // Untuk FakeStoreAPI (Modul 4)
      imageUrl = json['image'].toString();
    } else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      // Untuk EscuelaJS (Kode yang kamu kirim)
      imageUrl = json['images'][0].toString();
      imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    }

    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Tanpa Nama', // API biasanya menggunakan 'title'
      image: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
    );
  }
}