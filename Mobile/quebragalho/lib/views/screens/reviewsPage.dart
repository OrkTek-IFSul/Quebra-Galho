import 'package:flutter/material.dart';

/// Página que exibe as avaliações do serviço.
/// Utiliza um AppBar customizado e uma lista de avaliações.
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

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
          'Avaliações', // Título da página.
          style: TextStyle(
            color: Colors.purple, // Cor do texto púrpura.
            fontSize: 16, // Tamanho da fonte definido.
            fontWeight: FontWeight.w700, // Texto em negrito.
          ),
        ),
        centerTitle: true, // Centraliza o título na AppBar.
        actions: [
          // Área de ações na AppBar: exibição da nota média e ícone de estrela.
          Row(
            children: [
              Text(
                '3.5', // Nota média exibida.
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.star, // Ícone em forma de estrela.
                color: Colors.purple,
                size: 20,
              ),
              SizedBox(width: 16), // Espaçamento à direita.
            ],
          ),
        ],
      ),
      // Corpo da página com padding horizontal.
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinha o conteúdo à esquerda.
          children: [
            SizedBox(height: 16), // Espaçamento superior.
            // Texto informativo sobre o total de avaliações.
            Text(
              'Avaliações: 14',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16), // Espaçamento entre texto e lista.
            // Lista de avaliações utilizando ListView.builder.
            Expanded(
              child: ListView.builder(
                itemCount:
                    10, // Define o número de avaliações a serem exibidas.
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        // Linha que organiza o avatar, informações do usuário e a nota.
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start, // Alinha os itens pelo topo.
                          children: [
                            // Exibe o avatar do usuário com tamanho e cor definidos.
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            SizedBox(
                              width: 12,
                            ), // Espaçamento entre avatar e as informações.
                            // Coluna com o nome do usuário e o comentário/avaliação.
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start, // Alinha os textos à esquerda.
                                children: [
                                  Text(
                                    'José Silvano', // Nome do usuário avaliador.
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ), // Espaçamento entre o nome e o comentário.
                                  Text(
                                    'Lorem ipsumLorem ipsumLorem ipsumLorem ipsum.', // Conteúdo da avaliação.
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    overflow:
                                        TextOverflow
                                            .ellipsis, // Trunca o texto que ultrapassa o limite.
                                    maxLines:
                                        2, // Limite de linhas para exibição.
                                  ),
                                ],
                              ),
                            ),
                            // Exibe a nota dada na avaliação com ícone de estrela.
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.purple,
                                  size: 20,
                                ),
                                Text(
                                  '3', // Nota da avaliação.
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Linha divisória entre as avaliações.
                      Divider(color: Colors.grey.shade300, thickness: 1),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
