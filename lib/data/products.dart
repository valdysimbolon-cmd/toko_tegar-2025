import 'package:flutter/material.dart';

/// Nomor WhatsApp tujuan order (format internasional, tanpa + dan tanpa 0 di depan).
/// GANTI dengan nomor Anda.
const waNumber = '6281271768461';

/// 51900 -> "Rp51.900"
String rp(int v) =>
    'Rp${v.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.')}';

class HomeCategory {
  final String key, label, title, emoji;
  final Color color;
  final bool active; // hanya kategori aktif yang bisa dibuka
  const HomeCategory(
      this.key, this.label, this.title, this.emoji, this.color, this.active);
}

const homeCategories = [
  HomeCategory('terbaru', 'Produk\nTerbaru', 'Produk Terbaru', '🆕',
      Color(0xFFFFF59D), false),
  HomeCategory('belilagi', 'Beli Lagi', 'Beli Lagi', '🛒',
      Color(0xFFFFCDD2), false),
  HomeCategory('clearance', 'Clearance\nSale', 'Clearance Sale', '⏰',
      Color(0xFFE0E0E0), false),
  HomeCategory('sayur', 'Sayur', 'Aneka Sayur Segar', '🥬',
      Color(0xFFC8E6C9), true),
  HomeCategory('buah', 'Buah', 'Aneka Buah Segar', '🍊',
      Color(0xFFFFE0B2), true),
  HomeCategory('protein', 'Protein', 'Aneka Protein Segar', '🥩',
      Color(0xFFFFCCBC), true),
];

class Product {
  final String name, category, image, emoji;
  final int price, stok;
  final Color color; // warna latar placeholder jika gambar belum ada
  const Product(this.name, this.category, this.price, this.stok, this.image,
      this.emoji, this.color);
}

// Harga bebas ditentukan sendiri (sesuai soal). Di sini mengikuti contoh soal.
const products = [
  // PROTEIN (wajib)
  Product('Sayurbox Daging Giling Segar 250g', 'protein', 51900, 3,
      'assets/images/daging_giling.jpg', '🥩', Color(0xFFD7CCC8)),
  Product('Daging Has Luar Segar 250g', 'protein', 49900, 1,
      'assets/images/daging_has_luar.jpg', '🥩', Color(0xFFBCAAA4)),
  Product('Sayurbox Daging Sengkel Segar 250g', 'protein', 49900, 3,
      'assets/images/daging_sengkel.jpg', '🍖', Color(0xFFFFCCBC)),
  Product('Daging Has Dalam Segar 250g', 'protein', 62900, 5,
      'assets/images/daging_has_dalam.jpg', '🥩', Color(0xFFFFAB91)),
  Product('Sayurbox Iga Sapi Segar 250g', 'protein', 64900, 4,
      'assets/images/iga_sapi.jpg', '🍖', Color(0xFFD7CCC8)),
  Product('Teri Nasi Basah Tidak Baku', 'protein', 26100, 6,
      'assets/images/teri_nasi.jpg', '🐟', Color(0xFFCFD8DC)),
  // SAYUR (opsional)
  Product('Bayam Hijau 250g', 'sayur', 5900, 10, 'assets/images/bayam.jpg',
      '🌿', Color(0xFFC8E6C9)),
  Product('Kangkung 250g', 'sayur', 4900, 10, 'assets/images/kangkung.jpg',
      '🥬', Color(0xFFDCEDC8)),
  Product('Wortel 500g', 'sayur', 12900, 10, 'assets/images/wortel.jpg', '🥕',
      Color(0xFFFFE0B2)),
  // BUAH (opsional)
  Product('Jeruk Medan 1kg', 'buah', 32900, 10, 'assets/images/jeruk.jpg',
      '🍊', Color(0xFFFFE0B2)),
  Product('Apel Fuji 1kg', 'buah', 42900, 10, 'assets/images/apel.jpg', '🍎',
      Color(0xFFFFCDD2)),
  Product('Pisang Cavendish 1kg', 'buah', 21900, 10,
      'assets/images/pisang.jpg', '🍌', Color(0xFFFFF59D)),
];

/// Keranjang belanja (komponen bonus: "Lihat Keranjang").
class Cart extends ChangeNotifier {
  final Map<Product, int> _items = {};

  int qty(Product p) => _items[p] ?? 0;

  void add(Product p) {
    if (qty(p) < p.stok) {
      _items[p] = qty(p) + 1;
      notifyListeners();
    }
  }

  void remove(Product p) {
    final q = qty(p);
    if (q <= 1) {
      _items.remove(p);
    } else {
      _items[p] = q - 1;
    }
    notifyListeners();
  }

  Map<Product, int> get items => _items;
  int get count => _items.values.fold(0, (a, b) => a + b);
  int get total =>
      _items.entries.fold(0, (s, e) => s + e.key.price * e.value);
}

final cart = Cart();
