import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';
import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';
import 'package:quebragalho2/views/cliente/pages/tela_selecao_tipo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool manterLogado = false;
  bool carregando = true;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    verificarLoginAutomatico();
  }

  // --- A LÓGICA DE NEGÓCIO CONTINUA A MESMA ---
  Future<void> verificarLoginAutomatico() async {
    final prefs = await SharedPreferences.getInstance();
    final manter = prefs.getBool('manter_logado') ?? false;

    if (!manter) {
      setState(() => carregando = false);
      return;
    }

    final token = prefs.getString('token');
    final criadoEm = prefs.getString('token_criado_em');

    if (token != null && criadoEm != null) {
      final timestamp = DateTime.parse(criadoEm);
      final duracao = DateTime.now().difference(timestamp);
      const expiracao = Duration(hours: 1);

      if (duracao <= expiracao) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavegacaoCliente()),
        );
        return;
      } else {
        await prefs.remove('token');
        await prefs.remove('token_criado_em');
        await prefs.setBool('manter_logado', false);
      }
    }
    setState(() => carregando = false);
  }

  Future<void> salvarPreferencias(String token, int idUsuario, {int? idPrestador, String? nomeUsuario}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('usuario_id', idUsuario);
    await prefs.setString('token_criado_em', DateTime.now().toIso8601String());
    if (idPrestador != null) {
      await prefs.setInt('prestador_id', idPrestador);
    }
    if (nomeUsuario != null) {
      await prefs.setString('nome_usuario', nomeUsuario);
    }
    await prefs.setBool('manter_logado', manterLogado);
  }

  Future<void> fazerLogin() async {
  final email = emailController.text;
  final senha = senhaController.text;

  try {
    final response = await http.post(
      Uri.parse('https://${ApiConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      final idUsuario = body['id_usuario'];
      final nomeUsuario = body['nome'] ?? '';
      final idPrestador = body['id_prestador'];

      await salvarPreferencias(token, idUsuario, idPrestador: idPrestador, nomeUsuario: nomeUsuario);

      // PEGAR O TOKEN FCM
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('Token FCM: $fcmToken');

      if (fcmToken != null) {
        // ENVIAR O TOKEN PARA O BACKEND
        final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/getToken/$idUsuario?token=$fcmToken');
        final tokenResponse = await http.put(uri);

        if (tokenResponse.statusCode == 200 || tokenResponse.statusCode == 204) {
          print('Token FCM enviado com sucesso.');
        } else {
          print('Falha ao enviar token FCM: ${tokenResponse.statusCode}');
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou senha inválidos')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao conectar: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          // --- AÇÃO ATUALIZADA AQUI ---
          onPressed: () {
            // Navega para a HomePage e remove todas as rotas anteriores.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NavegacaoCliente()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Bem-vindo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Faça o login abaixo para acessar as principais funções do aplicativo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
              const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Mariaarshaad123@gmail.com',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 233, 233, 233),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: senhaController,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  hintText: '••••••••••',
                  filled: true,
                  fillColor: const Color.fromARGB(255, 233, 233, 233),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: manterLogado,
                        onChanged: (value) {
                          setState(() {
                            manterLogado = value ?? false;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 0, 0, 0),
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color.fromARGB(255, 0, 0, 0);
                          }
                          return Colors.grey[300];
                        }),
                      ),
                      const Text('Manter conectado', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implementar lógica de "Esqueci a Senha"
                    },
                    child: const Text(
                      'Esqueci a senha?',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: fazerLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CadastroPage()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 49, 49, 49),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color.fromARGB(255, 77, 77, 77)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Funções de obter ID permanecem as mesmas
Future<int?> obterIdUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('usuario_id');
}

Future<int?> obterIdPrestador() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('prestador_id');
}