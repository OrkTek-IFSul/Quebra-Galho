import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';
import 'package:quebragalho2/views/prestador/pages/navegacao_prestador.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // Importado para obterIdUsuario e obterIdPrestador
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/widgets/modal_cadastro_prestador.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int? usuarioId;
  int? id_Prestador;
  bool _isLoading = false; // Estado para controlar o carregamento

  @override
  void initState() {
    super.initState();
    // Carrega os IDs do usuário e do prestador ao iniciar a tela.
    carregarUsuario();
  }

  /// Carrega o ID do usuário e o ID do prestador (se existir)
  Future<void> carregarUsuario() async {
    final id = await obterIdUsuario();
    final idP = await obterIdPrestador();
    
    if (mounted) {
      setState(() {
        usuarioId = id;
        id_Prestador = idP;
      });
    }
  }

  /// Verifica na API se o usuário logado tem um vínculo de prestador.
  Future<bool> _checkPrestador(int userId) async {
    // Define o estado de carregamento como true para o feedback visual.
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/tipousuario/$userId'),
      );

      if (response.statusCode == 200) {
        // Se a resposta for bem-sucedida, decodifica o JSON.
        return json.decode(response.body) as bool;
      }
      // Retorna false em caso de outros status code.
      return false;
    } catch (e) {
      // Em caso de erro na requisição, imprime o erro e retorna false.
      print('Erro ao verificar prestador: $e');
      return false;
    } finally {
      // Garante que o estado de carregamento seja definido como false no final.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
              Image.asset(
                'assets/images/illustracao_telaselecaoperfil.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                "Seja bem-vindo(a) ao Quebra-Galho!\nEscolha como deseja continuar:",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 36),
              // Botão para entrar como Cliente
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navega para a tela principal do cliente.
                    // Usei pushReplacement para que o usuário não possa voltar a esta tela.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const NavegacaoCliente()),
                    );
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                  label: const Text(
                    "Sou Cliente",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Botão para entrar como Prestador
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color.fromARGB(255, 0, 0, 0), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Desabilita o botão se estiver em estado de carregamento.
                  onPressed: _isLoading
                      ? null
                      : () async {
                          // Garante que o ID do usuário foi carregado.
                          if (usuarioId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Aguarde, carregando dados...')),
                            );
                            return;
                          }

                          bool isPrestador = await _checkPrestador(usuarioId!);

                          // Verifica se o widget ainda está montado após a chamada assíncrona.
                          if (!mounted) return;

                          if (isPrestador) {
                            // Se o usuário já for um prestador, navega para a área do prestador.
                            if (id_Prestador != null) {
                               Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  // Assumindo que seu widget NavegacaoPrestador recebe o id do prestador.
                                  // Ajuste se o construtor for diferente.
                                  builder: (_) => NavegacaoPrestador(id_prestador: id_Prestador!),
                                ),
                              );
                            } else {
                               ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao carregar seu perfil de prestador.')),
                              );
                            }
                          } else {
                           showCadastroPrestadorModal(context);
                          }
                        },
                  icon: Icon(Icons.handyman, color: const Color.fromARGB(255, 0, 0, 0)),
                  label: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          "Sou Prestador",
                          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16, fontWeight: FontWeight.bold),
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