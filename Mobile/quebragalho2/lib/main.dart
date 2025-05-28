import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/pagina_navegacao.dart';
import 'package:quebragalho2/views/cliente/pages/tela_selecao_tipo.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MeusDados()
    );
  }
}
