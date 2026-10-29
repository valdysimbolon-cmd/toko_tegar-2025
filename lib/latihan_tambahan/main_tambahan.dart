import 'package:flutter/material.dart';
import 'pages/shell.dart';
import 'pages/detail_page.dart';
import 'pages/checkout_page.dart';

void main() => runApp(const TokoLatihanApp());

class TokoLatihanApp extends StatelessWidget {
  const TokoLatihanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Latihan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      // Named routes (halaman detail menerima data lewat arguments)
      routes: {
        '/': (_) => const LatihanShell(),
        '/detail': (_) => const DetailPage(),
        '/checkout': (_) => const CheckoutPage(),
      },
    );
  }
}
