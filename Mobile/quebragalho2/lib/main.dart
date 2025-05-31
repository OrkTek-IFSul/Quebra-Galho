import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:quebragalho2/views/cliente/pages/tela_selecao_tipo.dart';
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';
=======
import 'views/cliente/pages/cadastro_page.dart';
>>>>>>> 7ba3f5e7403d93651068c9c81a079a836c25e74f

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      home: PerfilPage()
=======
      title: 'Test Cadastro Page',
      home: CadastroPage(), // <- Aquí cargas solo esa página
>>>>>>> 7ba3f5e7403d93651068c9c81a079a836c25e74f
    );
  }
}
