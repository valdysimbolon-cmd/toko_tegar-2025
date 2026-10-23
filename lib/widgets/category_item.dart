import 'package:flutter/material.dart';
import '../data/products.dart';

/// Satu ikon kategori (Produk Terbaru, Beli Lagi, ..., Protein).
class CategoryItem extends StatelessWidget {
  final HomeCategory category;
  final double width;
  final bool selected;
  final VoidCallback onTap;
  const CategoryItem({
    super.key,
    required this.category,
    required this.width,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(12),
                  border: selected
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child:
                    Text(category.emoji, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(height: 4),
              Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
