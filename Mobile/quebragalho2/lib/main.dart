import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    int usuarioIdTeste = 1;
    int servicoIdTeste = 2;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()

    );
  }
}
