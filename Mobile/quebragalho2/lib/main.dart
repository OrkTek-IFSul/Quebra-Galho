import 'package:flutter/material.dart';
import 'views/cliente/pages/cadastro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Cadastro Page',
      home: CadastroPage(), // <- Aquí cargas solo esa página
    );
  }
}
