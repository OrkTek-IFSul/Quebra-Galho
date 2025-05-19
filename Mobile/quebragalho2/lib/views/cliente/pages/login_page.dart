import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// E-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              /// Senha
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),

              /// Texto clicável
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CadastroPage()),
                  );
                },
                child: Text(
                  "Ainda não tem conta?",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 12),

              /// Botão Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: Text("Entrar")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
