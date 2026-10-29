import 'package:flutter/material.dart';
import '../state.dart';
import '../widgets/item_card.dart';

/// Filter kategori (ChoiceChip) + urutkan (Dropdown) + GridView.builder.
class BerandaTab extends StatefulWidget {
  const BerandaTab({super.key});
  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab> {
  String _kat = 'Semua';
  String _urut = 'Nama';

  @override
  Widget build(BuildContext context) {
    final list = daftarItem
        .where((i) => _kat == 'Semua' || i.category == _kat)
        .toList();
    switch (_urut) {
      case 'Termurah':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Termahal':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        list.sort((a, b) => a.name.compareTo(b.name));
    }

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            itemCount: kategoriList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => ChoiceChip(
              label: Text(kategoriList[i]),
              selected: _kat == kategoriList[i],
              onSelected: (_) => setState(() => _kat = kategoriList[i]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text('${list.length} produk'),
              const Spacer(),
              DropdownButton<String>(
                value: _urut,
                underline: const SizedBox(),
                items: const ['Nama', 'Termurah', 'Termahal']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _urut = v!),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) => ItemCard(item: list[i]),
          ),
        ),
      ],
    );
  }
}
