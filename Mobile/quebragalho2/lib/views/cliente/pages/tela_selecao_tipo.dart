import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';
import 'dart:convert';


import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';
import 'package:quebragalho2/views/prestador/pages/navegacao_prestador.dart';

import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // arquivo onde voce coloca obterIdUsuario()

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  int? usuarioId;

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    final id = await obterIdUsuario();
    setState(() {
      usuarioId = id;
    });

  // Update function to handle boolean response
  Future<bool> _checkPrestador(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.155:8080/api/tipousuario/$userId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      }
      return false;
    } catch (e) {
      print('Error checking prestador: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/welcome.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                "Seja bem-vindo(a) ao App!\nEscolha como deseja continuar:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Passa usuarioId se quiser
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NavegacaoCliente(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                  label: const Text(
                    "Sou Cliente",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue.shade600, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    // Check if user is prestador
                    final isPrestador = await _checkPrestador(userId);
                    
                    if (isPrestador) {
                      // User is a prestador, navigate to NavegacaoPrestador
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NavegacaoPrestador(prestadorId: userId),
                        ),
                      );
                    } else {
                      // User is not a prestador, navigate to CadastroPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CadastroPage(),
                        ),
                      );
                    }

                  },
                  icon: Icon(Icons.handyman, color: Colors.blue.shade600),
                  label: Text(
                    "Sou Prestador",
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
