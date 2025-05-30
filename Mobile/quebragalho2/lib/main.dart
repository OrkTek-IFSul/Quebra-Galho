import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditarDadosPage(),
    );
  }
}
