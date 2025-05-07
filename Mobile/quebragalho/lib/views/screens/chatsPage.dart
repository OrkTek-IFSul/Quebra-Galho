import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/ChatPage.dart';
import 'package:flutter_quebragalho/views/widgets/chatItem.dart';

/// ChatsPage é um StatefulWidget que representa a tela de conversas.
class ChatsPage extends StatefulWidget {
  /// Construtor do widget.
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

/// Estado associado à ChatsPage que define a UI e sua lógica.
class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    // Scaffold cria a estrutura básica da tela com AppBar e body.
    return Scaffold(
      // AppBar é ajustado para ter altura zero, eliminando seu espaço visual.
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Define a altura do AppBar como 0.
        child: Container(), // Container vazio, pois o AppBar não será exibido.
      ),
      // O body da tela utiliza Padding para adicionar margens nas laterais e no topo.
      body: Padding(
        padding: EdgeInsets.only(
          left:
              MediaQuery.of(context).size.width *
              0.1, // 10% de espaçamento à esquerda.
          right:
              MediaQuery.of(context).size.width *
              0.1, // 10% de espaçamento à direita.
          top:
              MediaQuery.of(context).size.height *
              0.05, // 5% de espaçamento no topo.
        ),
        // Coluna organiza os widgets verticalmente.
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha os widgets à esquerda.
          children: [
            // Texto "Chats" serve como título da tela.
            Text(
              'Chats',
              style: TextStyle(
                color: Colors.purple, // Cor do texto definida como púrpura.
                fontSize: 24, // Tamanho da fonte.
                fontWeight: FontWeight.bold, // Texto em negrito.
              ),
            ),
            SizedBox(
              height: 16,
            ), // Espaçamento vertical entre o título e o campo de pesquisa.
            // Campo de pesquisa para filtrar chats.
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquise...', // Texto de dica para o usuário.
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ), // Estilo do texto de dica.
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 18,
                ), // Ícone de pesquisa posicionado à esquerda.
                // Borda padrão do TextField.
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Bordas arredondadas.
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ), // Define a cor da borda.
                ),
                // Borda quando o TextField está habilitado.
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ),
                ),
                // Borda ao focar o TextField.
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ),
                ),
                filled:
                    true, // Ativa o preenchimento do campo com uma cor definida.
                fillColor:
                    Colors.grey.shade200, // Cor de fundo do campo de pesquisa.
              ),
            ),
            SizedBox(
              height: 16,
            ), // Espaçamento entre o campo de pesquisa e a lista de chats.
            // Lista de chats exibida em um ListView.
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatPage()),
                      );
                    },
                    child: ChatItem(
                      name: 'Nome do Usuário',
                      message: 'Corpo da mensagem',
                      time: '15:36',
                      unreadCount: 2,
                    ),
                  ),
                  // Add more ChatItems here if needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
