import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';
import '../../../todo/data/isar_service.dart'; // Import IsarService
import '../../../todo/domain/todo_model.dart'; // Import Model Todo[cite: 2]

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  // LOGIKA FAVORITE: Menyimpan data produk ke Isar[cite: 2, 8]
  void _addToFavorite(BuildContext context, Product product) async {
    final isarService = locator<IsarService>();

    final favorite = Todo()
      ..title = product.name
      ..description = "Dipesan oleh Muhamad Taupik Anjana (20123005). Produk berkualitas tinggi dari katalog UTD Store." // Simpan Deskripsi
      ..imageUrl = product.image
      ..createdAt = DateTime.now() // Logika NIM: Simpan waktu sekarang
      ..isCompleted = false;

    await isarService.saveBookmark(favorite);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} ditambahkan ke Favorit!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productService = locator<ProductService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Detail Produk",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueAccent, Color(0xFF1A73E8)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Product?>(
        future: productService.fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return _buildErrorState();
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageHeader(product),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBadge(),
                            const SizedBox(height: 16),
                            _buildProductTitle(product),
                            const SizedBox(height: 10),
                            _buildProductId(product),
                            const SizedBox(height: 30),
                            _buildDescriptionSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // TOMBOL BOOKMARK/FAVORITE (Wajib untuk Modul 6)[cite: 2]
              _buildBottomAction(context, product),
            ],
          );
        },
      ),
    );
  }

  // --- UI Components ---

  Widget _buildBottomAction(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _addToFavorite(context, product),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        icon: const Icon(Icons.bookmark_add_rounded),
        label: const Text("TAMBAHKAN KE FAVORIT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ),
    );
  }

  Widget _buildImageHeader(Product product) {
    return Stack(
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent, Color(0xFF1A73E8)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 5)
              ],
            ),
            child: Hero(
              tag: 'prod_${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  product.image,
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductTitle(Product product) {
    return Text(
      product.name,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1E293B),
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildProductId(Product product) {
    return Row(
      children: [
        const Icon(Icons.qr_code_2_rounded, size: 18, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(
          "ID Produk: ${product.id}",
          style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Deskripsi Produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          "Produk ini merupakan bagian dari katalog UTD Store oleh Muhamad Taupik Anjana (20123005). Menjamin kualitas terbaik dengan harga bersaing bagi mahasiswa.",
          style: TextStyle(color: Colors.grey[700], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "ORIGINAL PRODUCT",
        style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
          const SizedBox(height: 10),
          const Text("Gagal memuat detail produk"),
        ],
      ),
    );
  }
}