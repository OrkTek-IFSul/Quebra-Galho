import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/perfil_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const int usuarioIdTeste = 1;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerfilPage(usuarioId: usuarioIdTeste),
    );
  }
}
