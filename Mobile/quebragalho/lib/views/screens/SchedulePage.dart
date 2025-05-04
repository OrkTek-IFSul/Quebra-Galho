import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/widgets/SchedulePickerWidget.dart';

/// Página que exibe as avaliações do serviço.
/// Utiliza um AppBar customizado e uma lista de avaliações.
class Schedulepage extends StatelessWidget {
  const Schedulepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar customizado sem elevação e com título centralizado.
      appBar: AppBar(
        backgroundColor: Colors.white, // Define a cor de fundo branco.
        elevation: 0, // Remove a sombra (elevação).
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.purple,
          ), // Ícone de voltar com cor púrpura.
          onPressed: () {
            Navigator.pop(
              context,
            ); // Ao pressionar, volta para a tela anterior.
          },
        ),
        title: Text(
          'Agendar Serviço', // Título da página.
          style: TextStyle(
            color: Colors.purple, // Cor do texto púrpura.
            fontSize: 22, // Tamanho da fonte definido.
            fontWeight: FontWeight.w700, // Texto em negrito.
          ),
        ),
        centerTitle: true, // Centraliza o título na AppBar.
      ),
      // Corpo da página com padding horizontal.
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  SchedulePickerWidget(), // Widget separado para manter o código limpo
            ),
            Spacer(),
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
                  "Solicitar",
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
      ),
    );
  }
}
