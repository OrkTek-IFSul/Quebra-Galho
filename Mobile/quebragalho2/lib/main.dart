import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/avaliacoes_prestador.dart';
import 'package:quebragalho2/views/moderador/pages/moderador_page.dart';
import 'package:quebragalho2/views/prestador/pages/avaliacoes_page_detalhes.dart';
import 'package:quebragalho2/views/prestador/pages/lista_avaliacoes.dart';
import 'package:quebragalho2/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ModeradorPage(),
    );
  }
}
