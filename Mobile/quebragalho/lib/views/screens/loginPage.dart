import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/HomePage.dart';
import 'package:flutter_quebragalho/views/screens/signUpPage.dart';
import 'package:http/http.dart' as http;

/// LoginPage é um StatefulWidget que representa a tela de login do app.
class LoginPage extends StatefulWidget {
  // Construtor padrão do widget.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Estado associado à LoginPage, onde a UI e a lógica são definidas.
class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  Future<void> _realizarLogin() async {
    final String email = emailController.text.trim();
    final String senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos."), backgroundColor: Colors.red),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.7:8080/auth/login'); 

    try {
      final resposta = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (resposta.statusCode == 200) {
        final token = jsonDecode(resposta.body)['token'];
        print('TOKEN RECEBIDO: $token');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login realizado com sucesso."), backgroundColor: Colors.green),
        );

        // TODO: Salvar o token em local seguro (como shared_preferences)

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no login: ${resposta.statusCode}"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.red),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O corpo principal da tela com padding horizontal.
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0), // Espaçamento nas laterais.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente os elementos.
          crossAxisAlignment: CrossAxisAlignment.stretch, // Faz com que os elementos se estiquem horizontalmente.
          children: [
            // LOGO: Espaço reservado para um widget de logo (não implementado aqui).

            // Texto de boas-vindas com quebra de linha.
            Text(
              "Seja\nbem-vindo!",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 35, // Tamanho grande para destaque.
                fontWeight: FontWeight.bold, // Texto em negrito.
                color: Colors.purple, // Cor do texto.
              ),
            ),
            SizedBox(height: 8), // Espaçamento vertical curto.

            // Parágrafo explicativo para o usuário.
            Text(
              "Adicione suas credenciais para acessar os serviços do app",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20, // Tamanho adequado para leitura.
                color: const Color.fromARGB(255, 151, 151, 151), // Cor cinza para texto secundário.
                fontWeight: FontWeight.w600, // Leve destaque no peso do texto.
              ),
            ),
            SizedBox(height: 34), // Espaçamento antes dos inputs.

            // Rótulo para o campo de Email/Telefone.
            Text(
              "EMAIL / TELEFONE",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Espaçamento entre o rótulo e o campo.
            // Campo de texto para entrada de Email ou Telefone.
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(), // Exibe somente uma borda inferior.
                labelText: 'Email ou Telefone', // Rótulo que fica flutuante.
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os campos.

            // Rótulo para o campo de Senha.
            Text(
              "SENHA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Espaçamento entre o rótulo e o campo.
            // Campo de texto para a senha, com obscureText ativado para esconder o conteúdo.
            TextField(
              controller: senhaController,
              obscureText: true, // Esconde o texto digitado.
              decoration: InputDecoration(
                border: UnderlineInputBorder(), // Exibe somente a borda inferior.
                labelText: 'Senha', // Rótulo para o campo.
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os campos.

            // Linha que agrupa o checkbox "Manter conectado" e o botão "Esqueceu sua senha?".
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribui os elementos nas extremidades.
              children: [
                Row(
                  children: [
                    // Checkbox para selecionar a opção de manter o usuário conectado.
                    Checkbox(
                      value: isChecked, // Valor atual do checkbox.
                      onChanged: (value) {
                        // Atualiza o estado do checkbox.
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    // Texto descritivo para o checkbox.
                    Text("Manter conectado"),
                  ],
                ),
                // Botão de texto para ação de "Esqueceu sua senha?".
                TextButton(
                  onPressed: () {
                    // Ação a ser definida para recuperação de senha.
                  },
                  child: Text(
                    "Esqueceu sua senha?",
                    style: TextStyle(color: Colors.purple), // Destaca com cor púrpura.
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Área inferior da tela contendo RichText e o botão "Acessar".
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: "Ainda não é usuário? ",
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                  children: [
                    TextSpan(
                      text: "Cadastre-se",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 129, 11, 150),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 80,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _realizarLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text("Acessar", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}