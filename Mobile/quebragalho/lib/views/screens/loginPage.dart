import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_quebragalho/views/screens/signUpPage.dart';

/// LoginPage é um StatefulWidget que representa a tela de login do app.
class LoginPage extends StatefulWidget {
  // Construtor padrão do widget.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Estado associado à LoginPage, onde a UI e a lógica são definidas.
class _LoginPageState extends State<LoginPage> {
  // Variável para controlar o estado do Checkbox "Manter conectado".
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O corpo principal da tela com padding horizontal.
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ), // Espaçamento nas laterais.
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center, // Centraliza verticalmente os elementos.
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch, // Faz com que os elementos se estiquem horizontalmente.
          children: [
            // LOGO: Espaço reservado para um widget de logo (não implementado aqui).

            // Texto de boas-vindas com quebra de linha.
            Text(
              "Seja\nbem-vindo!",
              textAlign: TextAlign.left, // Alinhamento à esquerda.
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
                color: const Color.fromARGB(
                  255,
                  151,
                  151,
                  151,
                ), // Cor cinza para texto secundário.
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
              decoration: InputDecoration(
                border:
                    UnderlineInputBorder(), // Exibe somente uma borda inferior.
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
              obscureText: true, // Esconde o texto digitado.
              decoration: InputDecoration(
                border:
                    UnderlineInputBorder(), // Exibe somente a borda inferior.
                labelText: 'Senha', // Rótulo para o campo.
              ),
            ),
            SizedBox(height: 16), // Espaçamento entre os campos.
            // Linha que agrupa o checkbox "Manter conectado" e o botão "Esqueceu sua senha?".
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween, // Distribui os elementos nas extremidades.
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
                    style: TextStyle(
                      color: Colors.purple,
                    ), // Destaca com cor púrpura.
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // Área inferior da tela contendo RichText e o botão "Acessar".
      bottomNavigationBar: Column(
        mainAxisSize:
            MainAxisSize
                .min, // Ajusta a coluna para o tamanho mínimo necessário.
        children: [
          // Espaço com o texto informativo e link para cadastro.
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: "Ainda não é usuário? ", // Texto padrão.
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                  children: [
                    // Texto que funciona como link para a página de cadastro.
                    TextSpan(
                      text: "Cadastre-se",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 129, 11, 150),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // Navega para a página de cadastro ao ser acionado.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botão "Acessar" que ocupa a largura total.
          SizedBox(
            height: 80, // Altura definida para o botão.
            width: double.infinity, // Ocupa toda a largura.
            child: ElevatedButton(
              onPressed: () {
                // Ação de login a ser implementada.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Cor de fundo do botão.
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Sem cantos arredondados.
                ),
              ),
              child: Text(
                "Acessar",
                style: TextStyle(
                  fontSize: 20, // Tamanho de fonte adequado.
                  color: Colors.white, // Texto na cor branca para contraste.
                  fontWeight:
                      FontWeight.bold, // Texto em negrito para destaque.
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
