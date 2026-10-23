import 'package:flutter/material.dart';
import '../data/products.dart';
import 'product_image.dart';

/// Item produk di grid 3 kolom (halaman Protein).
/// Klik tile -> halaman detail. Tombol + / - -> keranjang (bonus).
class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductTile({super.key, required this.product, required this.onTap});

  Widget _circle(IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        final q = cart.qty(product);
        return InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ProductImage(product: product),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: _circle(
                          Icons.add, Colors.green.shade700, () => cart.add(product)),
                    ),
                    if (q > 0)
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Row(
                          children: [
                            _circle(Icons.remove, Colors.green.shade700,
                                () => cart.remove(product)),
                            const SizedBox(width: 4),
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle),
                              child: Text('$q',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(rp(product.price),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
              Text(product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10)),
              Align(
                alignment: Alignment.centerRight,
                child: Text('Sisa ${product.stok}',
                    style: const TextStyle(fontSize: 10, color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}
