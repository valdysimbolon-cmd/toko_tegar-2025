import 'package:flutter/material.dart';
import '../state.dart';
import '../util.dart';

/// Profil: TabBar (Data Toko | Favorit) + edit profil lewat BottomSheet + Form.
class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  void _edit(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final toko = TextEditingController(text: app.profil.namaToko);
    final pemilik = TextEditingController(text: app.profil.namaPemilik);
    final kontak = TextEditingController(text: app.profil.kontak);
    String? wajib(String? v) =>
        (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  controller: toko,
                  decoration: const InputDecoration(labelText: 'Nama Toko'),
                  validator: wajib),
              TextFormField(
                  controller: pemilik,
                  decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                  validator: wajib),
              TextFormField(
                  controller: kontak,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Kontak'),
                  validator: wajib),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    app.ubahProfil(toko.text.trim(), pemilik.text.trim(),
                        kontak.text.trim());
                    Navigator.pop(ctx);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataToko(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
              child: CircleAvatar(radius: 40, child: Text('🏪', style: TextStyle(fontSize: 36)))),
          const SizedBox(height: 16),
          ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Nama Toko'),
              subtitle: Text(app.profil.namaToko)),
          ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Nama Pemilik'),
              subtitle: Text(app.profil.namaPemilik)),
          ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Kontak'),
              subtitle: Text(app.profil.kontak)),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _edit(context),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profil'),
          ),
        ],
      ),
    );
  }

  Widget _favorit() {
    return ListenableBuilder(
      listenable: app,
      builder: (context, _) {
        final fav = app.daftarFavorit;
        if (fav.isEmpty) {
          return const Center(child: Text('Belum ada produk favorit'));
        }
        return ListView.builder(
          itemCount: fav.length,
          itemBuilder: (context, i) => ListTile(
            leading: CircleAvatar(
                backgroundColor: warnaItem(fav[i]), child: Text(fav[i].emoji)),
            title: Text(fav[i].name),
            subtitle: Text(rupiah(fav[i].price)),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => app.toggleFav(fav[i]),
            ),
            onTap: () =>
                Navigator.pushNamed(context, '/detail', arguments: fav[i]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(tabs: [Tab(text: 'Data Toko'), Tab(text: 'Favorit')]),
          Expanded(
            child: TabBarView(children: [_dataToko(context), _favorit()]),
          ),
        ],
      ),
    );
  }
}
