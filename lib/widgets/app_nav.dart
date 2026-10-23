import 'package:flutter/material.dart';

/// Navigation bottom: Home, Search, Keranjang, Profil (komponen wajib).
class AppNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const AppNav({super.key, required this.index, required this.onTap});

  static const _icons = [
    Icons.home,
    Icons.search,
    Icons.shopping_basket_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (i) {
            return IconButton(
              onPressed: () => onTap(i),
              icon: Icon(_icons[i],
                  color: i == index ? Colors.deepOrange : Colors.black54),
            );
          }),
        ),
      ),
    );
  }
}
