import 'package:flutter/material.dart';

class Item {
  final int id;
  final String name, category, emoji;
  final int price, stok;
  const Item(
      this.id, this.name, this.category, this.price, this.stok, this.emoji);
}

Color warnaItem(Item i) =>
    Colors.primaries[i.id % Colors.primaries.length].shade100;

const kategoriList = ['Semua', 'Sayur', 'Buah', 'Protein', 'Sembako'];

const daftarItem = [
  Item(1, 'Bayam Hijau 250g', 'Sayur', 5900, 10, '🌿'),
  Item(2, 'Kangkung 250g', 'Sayur', 4900, 8, '🥬'),
  Item(3, 'Wortel 500g', 'Sayur', 12900, 6, '🥕'),
  Item(4, 'Jeruk Medan 1kg', 'Buah', 32900, 5, '🍊'),
  Item(5, 'Apel Fuji 1kg', 'Buah', 42900, 4, '🍎'),
  Item(6, 'Pisang Cavendish 1kg', 'Buah', 21900, 7, '🍌'),
  Item(7, 'Daging Giling Segar 250g', 'Protein', 51900, 3, '🥩'),
  Item(8, 'Iga Sapi Segar 250g', 'Protein', 64900, 4, '🍖'),
  Item(9, 'Teri Nasi Basah', 'Protein', 26100, 6, '🐟'),
  Item(10, 'Beras Premium 5kg', 'Sembako', 74900, 9, '🍚'),
  Item(11, 'Minyak Goreng 1L', 'Sembako', 18900, 12, '🛢️'),
  Item(12, 'Gula Pasir 1kg', 'Sembako', 16500, 10, '🧂'),
];

class Profil {
  String namaToko, namaPemilik, kontak;
  Profil(this.namaToko, this.namaPemilik, this.kontak);
}

/// State global sederhana (ChangeNotifier): profil, keranjang, favorit.
class AppState extends ChangeNotifier {
  Profil profil = Profil('Toko Tegar', 'Tegar Arifin', '08123456789');
  final Map<int, int> _keranjang = {}; // id item -> jumlah
  final Set<int> _favorit = {};

  // ---- Keranjang ----
  int qty(Item i) => _keranjang[i.id] ?? 0;

  void tambah(Item i, [int n = 1]) {
    final baru = (qty(i) + n).clamp(0, i.stok);
    _keranjang[i.id] = baru;
    notifyListeners();
  }

  void kurang(Item i) {
    final q = qty(i);
    if (q <= 1) {
      _keranjang.remove(i.id);
    } else {
      _keranjang[i.id] = q - 1;
    }
    notifyListeners();
  }

  void hapus(Item i) {
    _keranjang.remove(i.id);
    notifyListeners();
  }

  void kosongkan() {
    _keranjang.clear();
    notifyListeners();
  }

  List<MapEntry<Item, int>> get isiKeranjang => _keranjang.entries
      .map((e) => MapEntry(daftarItem.firstWhere((i) => i.id == e.key), e.value))
      .toList();

  int get jumlah => _keranjang.values.fold(0, (a, b) => a + b);
  int get total =>
      isiKeranjang.fold(0, (s, e) => s + e.key.price * e.value);

  // ---- Favorit ----
  bool isFav(Item i) => _favorit.contains(i.id);

  void toggleFav(Item i) {
    if (!_favorit.add(i.id)) _favorit.remove(i.id);
    notifyListeners();
  }

  List<Item> get daftarFavorit =>
      daftarItem.where((i) => _favorit.contains(i.id)).toList();

  // ---- Profil ----
  void ubahProfil(String toko, String pemilik, String kontak) {
    profil = Profil(toko, pemilik, kontak);
    notifyListeners();
  }
}

final app = AppState();
