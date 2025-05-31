import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/detalhes_solicitacao_page.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';
import 'package:quebragalho2/views/cliente/pages/minhas_solicitacoes_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MinhasSolicitacoesPage(),
    );
  }
}
