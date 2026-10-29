import '../latihan_tambahan/state.dart' show app;
import 'package:flutter/material.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaToko = TextEditingController();
  final _namaPemilik = TextEditingController();
  final _alamat = TextEditingController();
  final _kontak = TextEditingController();

  static const _jenisUsaha = [
    'Makanan & Minuman',
    'Sayur & Sembako',
    'Elektronik',
    'Fashion',
    'Lainnya',
  ];
  String _jenis = 'Makanan & Minuman';
  bool _setuju = false;

  @override
  void dispose() {
    _namaToko.dispose();
    _namaPemilik.dispose();
    _alamat.dispose();
    _kontak.dispose();
    super.dispose();
  }

  String? _wajib(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan')),
      );
      return;
    }
        app.ubahProfil(_namaToko.text.trim(), _namaPemilik.text.trim(),
        _kontak.text.trim());
    // Kirim Nama Toko ke halaman berikutnya lewat constructor
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(storeName: _namaToko.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Pemilik Toko')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaToko,
                decoration: const InputDecoration(labelText: 'Nama Toko'),
                validator: _wajib,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaPemilik,
                decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                validator: _wajib,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _jenis,
                decoration: const InputDecoration(labelText: 'Jenis Usaha'),
                items: _jenisUsaha
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _jenis = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _alamat,
                decoration: const InputDecoration(labelText: 'Alamat Toko'),
                validator: _wajib,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kontak,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Kontak'),
                validator: _wajib,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _setuju,
                onChanged: (v) => setState(() => _setuju = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Saya menyetujui syarat dan ketentuan',
                    style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
