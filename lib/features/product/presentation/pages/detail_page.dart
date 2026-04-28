import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Memanggil ProductService dari locator (GetIt)
    final productService = locator<ProductService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk")),
      body: FutureBuilder<Product?>(
        // Memanggil fungsi fetchProductDetail yang mengembalikan Future
        future: productService.fetchProductDetail(productId),
        builder: (context, snapshot) {
          // 1. Kondisi saat sedang menunggu data (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Kondisi jika terjadi error atau data tidak ditemukan
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          // 3. Data berhasil didapat, masukkan ke dalam variabel product
          final product = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    product.image,
                    height: 250,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "ID Produk: ${product.id}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}