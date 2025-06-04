import 'package:flutter/material.dart';

import 'package:quebragalho2/views/cliente/pages/tela_selecao_tipo.dart';
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';

import 'views/cliente/pages/cadastro_page.dart';
import 'package:quebragalho2/views/prestador/pages/pagina_de_navegacao.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';
import 'package:quebragalho2/views/cliente/pages/perfil_page.dart';

import 'package:quebragalho2/views/cliente/pages/detalhes_solicitacao_page.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';
import 'package:quebragalho2/views/cliente/pages/minhas_solicitacoes_page.dart';

import 'package:quebragalho2/views/cliente/pages/pagina_navegacao.dart';

import 'package:quebragalho2/views/cliente/pages/tela_selecao_tipo.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    const int usuarioIdTeste = 1;
    const int servicoIdTeste = 2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaDeNavegacao()

    );
  }
}
