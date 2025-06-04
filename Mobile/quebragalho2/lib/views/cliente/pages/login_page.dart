import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';
import 'dart:convert';
import 'package:quebragalho2/views/cliente/pages/tela_selecao_tipo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quebragalho2/api_config.dart';

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

  @override
  void initState() {
    super.initState();
    verificarLoginAutomatico();
  }

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
          MaterialPageRoute(builder: (_) => const WelcomePage()), // Ajuste se necessário
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

  Future<void> salvarPreferencias(String token, int id) async {
    final prefs = await SharedPreferences.getInstance();
    if (manterLogado) {
      await prefs.setBool('manter_logado', true);
      await prefs.setString('token', token);
      await prefs.setInt('usuario_id', id);   // salva id do usuário aqui
      await prefs.setString('token_criado_em', DateTime.now().toIso8601String());
    } else {
      await prefs.setBool('manter_logado', false);
    }

    print('Token salvo: $token');
    print('ID do usuário salvo: $id');
  }

  Future<void> fazerLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    try {
      final url = Uri.parse('http://${ApiConfig.baseUrl}/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body['token'];
        final id = body['id_usuario'];  // Confirme que a API retorna esse campo

        await salvarPreferencias(token, id);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),  // Ajuste a tela que vai após o login
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
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: manterLogado,
                  onChanged: (value) {
                    setState(() {
                      manterLogado = value ?? false;
                    });
                  },
                ),
                const Text('Continuar logado'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: fazerLogin,
                    child: const Text('Entrar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CadastroPage()),
                      );
                    },
                    child: const Text('Fazer Cadastro'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Função que as outras telas vão usar para obter o ID do usuário
Future<int?> obterIdUsuario() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('usuario_id');
}
