import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';
import 'dart:convert';

import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';
import 'package:quebragalho2/views/prestador/pages/navegacao_prestador.dart';

// Assuming obterIdUsuario() is correctly defined in login_page.dart
// and returns Future<int?>
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int? usuarioId; // Stores the ID of the logged-in user

  @override
  void initState() {
    super.initState();
    // Load the user ID when the widget is initialized
    _carregarUsuario();
  }

  /// Fetches the user ID using obterIdUsuario() and updates the state.
  Future<void> _carregarUsuario() async {
    // obtainerIdUsuario is expected to be defined in your login_page.dart
    // and should return the user's ID, or null if not logged in/found.
    final id = await obterIdUsuario();
    if (mounted) { // Check if the widget is still in the tree
      setState(() {
        usuarioId = id;
      });
    }
  }

  /// Checks if the user with the given [userId] is a "Prestador".
  ///
  /// Makes an HTTP GET request to your API.
  /// Returns `true` if the user is a "Prestador", `false` otherwise or on error.
  Future<bool> _checkPrestador(int userId) async {
    try {
      final response = await http.get(
        // Ensure this IP address is correct and your backend is running
        Uri.parse('${ApiConfig.baseUrl}/api/tipousuario/$userId'),
      );

      if (response.statusCode == 200) {
        // The API is expected to return a boolean value directly
        return json.decode(response.body) as bool;
      }
      // If status code is not 200, assume not a prestador or an error occurred
      print('Failed to check prestador status: ${response.statusCode}');
      return false;
    } catch (e) {
      // Handles network errors or issues with parsing the response
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
                'assets/welcome.json', // Your Lottie animation file
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
                    // Navigate to the client navigation screen
                    // You could pass usuarioId here if NavegacaoCliente needs it
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
                    // Check if usuarioId has been loaded
                    if (usuarioId == null) {
                      print("User ID not loaded yet. Cannot check prestador status.");
                      // Optionally, show a SnackBar or a dialog to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Aguarde, carregando dados do usuário...")),
                      );
                      return; // Exit if no usuarioId
                    }

                    // Show a loading indicator while checking
                    // You might want to implement a more sophisticated loading state
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    final bool isPrestador = await _checkPrestador(usuarioId!); // Use '!' because we checked for null

                    if (mounted) { // Check if the widget is still mounted before updating UI
                       Navigator.pop(context); // Dismiss the loading indicator

                      if (isPrestador) {
                        // User is a prestador, navigate to NavegacaoPrestador
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            // Pass the prestadorId to the navigation screen
                            builder: (_) => NavegacaoPrestador(prestadorId: usuarioId!),
                          ),
                        );
                      } else {
                        // User is not a prestador, navigate to CadastroPage to register as one
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroPage(), // Assuming CadastroPage is for becoming a prestador
                          ),
                        );
                      }
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