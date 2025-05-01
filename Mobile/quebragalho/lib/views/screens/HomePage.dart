import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/ChatPage.dart';
import 'package:flutter_quebragalho/views/widgets/chatItem.dart';

/// HomePage é um StatefulWidget que representa a tela de conversas.
class HomePage extends StatefulWidget {
  /// Construtor do widget.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Estado associado à HomePage que define a UI e sua lógica.
class _HomePageState extends State<HomePage> {
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
            Row(
              children: [
                Text(
                  'O que você precisa ',
                  style: TextStyle(
                    color: Colors.purple, // Cor do texto definida como púrpura.
                    fontSize: 22, // Tamanho da fonte.
                  ),
                ),
                Text(
                  'hoje?',
                  style: TextStyle(
                    color: Colors.purple, // Cor do texto definida como púrpura.
                    fontSize: 22, // Tamanho da fonte.
                    fontWeight: FontWeight.bold, // Texto em negrito.
                  ),
                ),
                Spacer(),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.notifications_none_outlined),
                  color: Colors.purple,
                  onPressed: () {},
                ),
              ],
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
            Row(
              children: [
                Text(
                  'Destaques',
                  style: TextStyle(
                    color: Colors.grey, // Cor do texto definida como púrpura.
                    fontSize: 14, // Tamanho da fonte.
                  ),
                ),
                Spacer(),
                //Botão Ver mais
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Ver mais',
                    style: TextStyle(
                      color:
                          Colors.purple, // Cor do texto definida como púrpura.
                      fontSize: 14, // Tamanho da fonte.
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 140,
              //Lista de Destaques
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 220,
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.purple,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    "https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png",
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nome Template',
                                  style: TextStyle(
                                    color:
                                        Colors
                                            .black, // Cor do texto definida como púrpura.
                                    fontSize: 12, // Tamanho da fonte.
                                  ),
                                ),
                                Text(
                                  'Tag Template',
                                  style: TextStyle(
                                    color:
                                        Colors
                                            .purple, // Cor do texto definida como púrpura.
                                    fontSize: 12, // Tamanho da fonte.
                                    backgroundColor: Colors.purple.shade100,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "R\$ ",
                                      style: TextStyle(
                                        color:
                                            Colors
                                                .purple, // Cor do texto definida como púrpura.
                                        fontSize: 12, // Tamanho da fonte.
                                      ),
                                    ),
                                    Text(
                                      "99",
                                      style: TextStyle(
                                        color:
                                            Colors
                                                .purple, // Cor do texto definida como púrpura.
                                        fontSize: 22, // Tamanho da fonte.
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "/h ",
                                      style: TextStyle(
                                        color:
                                            Colors
                                                .purple, // Cor do texto definida como púrpura.
                                        fontSize: 12, // Tamanho da fonte.
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Add more Cards here if needed
                ],
              ),
            ),
            //Lista de categorias
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Todos',
                    style: TextStyle(
                      color:
                          Colors.purple, // Cor do texto definida como púrpura.
                      fontSize: 14, // Tamanho da fonte.
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.purple,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Mecânico',
                    style: TextStyle(
                      color: Colors.grey, // Cor do texto definida como púrpura.
                      fontSize: 14, // Tamanho da fonte.
                    ),
                  ),
                ),
              ],
            ),
            //Lista de Profissionais por categoria
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.purple,
                        onTap: () {
                          debugPrint('Card tapped.');
                        },
                        child: Row(
                          children: [
                            const SizedBox(
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    "https://gru.ifsp.edu.br/images/phocagallery/galeria2/image03_grd.png",
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nome Template',
                                  style: TextStyle(
                                    color:
                                        Colors
                                            .black, // Cor do texto definida como púrpura.
                                    fontSize: 12, // Tamanho da fonte.
                                  ),
                                ),
                                Text(
                                  'Tag Template',
                                  style: TextStyle(
                                    color:
                                        Colors
                                            .purple, // Cor do texto definida como púrpura.
                                    fontSize: 12, // Tamanho da fonte.
                                    backgroundColor: Colors.purple.shade100,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "R\$ ",
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .purple, // Cor do texto definida como púrpura.
                                      fontSize: 12, // Tamanho da fonte.
                                    ),
                                  ),
                                  Text(
                                    "99",
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .purple, // Cor do texto definida como púrpura.
                                      fontSize: 22, // Tamanho da fonte.
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "/h ",
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .purple, // Cor do texto definida como púrpura.
                                      fontSize: 12, // Tamanho da fonte.
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  // Add more Cards here if needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
