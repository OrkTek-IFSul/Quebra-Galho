import 'package:flutter/material.dart';

/// Página que exibe as avaliações do serviço.
/// Utiliza um AppBar customizado e uma lista de avaliações.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
          'Notificações', // Título da página.
          style: TextStyle(
            color: Colors.purple, // Cor do texto púrpura.
            fontSize: 22, // Tamanho da fonte definido.
            fontWeight: FontWeight.w700, // Texto em negrito.
          ),
        ),
        centerTitle: true, // Centraliza o título na AppBar.
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
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'As últimas',
                    style: TextStyle(
                      color: Colors.grey, // Cor do texto definida como púrpura.
                      fontSize: 12, // Tamanho da fonte.
                    ),
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    // Ação do botão
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.purple,
                    ), // Cor da borda
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    foregroundColor: Colors.purple, // Cor do texto e do ícone
                  ),
                  child: const Text(
                    'Marcar todas como lida',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Espaçamento entre texto e lista.
            // Lista de notificações utilizando ListView.builder.
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        child: Card(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            splashColor: Colors.white,
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
                                    Row(
                                      children: [
                                        Text(
                                          'Nome Template'
                                          ' ', //espaço entre os textos
                                          style: TextStyle(
                                            color:
                                                Colors
                                                    .purple, // Cor do texto definida como púrpura.
                                            fontSize: 12, // Tamanho da fonte.
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Aceitou sua solicitação!',
                                          style: TextStyle(
                                            color:
                                                Colors
                                                    .purple, // Cor do texto definida como púrpura.
                                            fontSize: 12, // Tamanho da fonte.
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors
                                                    .purple
                                                    .shade100, // Cor de fundo
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ), // Borda arredondada
                                          ),
                                          child: const Text(
                                            'Iniciar chat',
                                            style: TextStyle(
                                              color: Colors.purple,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 12.0,
                                          ),
                                          child: Text(
                                            'date - time',
                                            style: TextStyle(
                                              color:
                                                  Colors
                                                      .grey, // Cor do texto definida como púrpura.
                                              fontSize: 12, // Tamanho da fonte.
                                            ),
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
                      Divider(),
                      // Add more Cards here if needed
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
