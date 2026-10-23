import 'package:flutter/material.dart';
import '../data/products.dart';

/// Gambar produk dari assets. Jika file belum ada, tampil placeholder emoji.
class ProductImage extends StatelessWidget {
  final Product product;
  final double? height;
  final double emojiSize;
  const ProductImage(
      {super.key, required this.product, this.height, this.emojiSize = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: product.color,
      height: height,
      width: double.infinity,
      child: Image.asset(
        product.image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stack) => Center(
          child: Text(product.emoji, style: TextStyle(fontSize: emojiSize)),
        ),
      ),
    );
  }
}
