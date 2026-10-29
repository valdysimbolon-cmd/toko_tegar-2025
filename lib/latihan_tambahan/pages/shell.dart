import 'package:flutter/material.dart';
import '../state.dart';
import 'beranda_tab.dart';
import 'cari_tab.dart';
import 'keranjang_tab.dart';
import 'profil_tab.dart';

/// Halaman utama: Drawer + NavigationBar (badge jumlah keranjang) + IndexedStack.
class LatihanShell extends StatefulWidget {
  const LatihanShell({super.key});
  @override
  State<LatihanShell> createState() => _LatihanShellState();
}

class _LatihanShellState extends State<LatihanShell> {
  int _tab = 0;
  static const _judul = ['Beranda', 'Pencarian', 'Keranjang', 'Profil'];

  void _pindah(int i) => setState(() => _tab = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_tab])),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              ListenableBuilder(
                listenable: app,
                builder: (context, _) => ListTile(
                  leading: const Icon(Icons.store),
                  title: Text(app.profil.namaToko,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(app.profil.namaPemilik),
                ),
              ),
              const Divider(),
              for (int i = 0; i < _judul.length; i++)
                ListTile(
                  title: Text(_judul[i]),
                  selected: _tab == i,
                  onTap: () {
                    Navigator.pop(context);
                    _pindah(i);
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Tentang Aplikasi'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: 'Toko Latihan',
                    applicationVersion: '1.0',
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: const [BerandaTab(), CariTab(), KeranjangTab(), ProfilTab()],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: app,
        builder: (context, _) => NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: _pindah,
          destinations: [
            const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda'),
            const NavigationDestination(
                icon: Icon(Icons.search), label: 'Cari'),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: app.jumlah > 0,
                label: Text('${app.jumlah}'),
                child: const Icon(Icons.shopping_basket_outlined),
              ),
              label: 'Keranjang',
            ),
            const NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
