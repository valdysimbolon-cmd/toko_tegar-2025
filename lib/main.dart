import 'package:flutter/material.dart';
import 'pages/register_page.dart';

void main() => runApp(const TokoTegarApp());

class TokoTegarApp extends StatelessWidget {
  const TokoTegarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Tegar',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const RegisterPage(),
    );
  }
}
