import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/views/screens/SchedulePage.dart';
import 'package:flutter_quebragalho/views/screens/reviewsPage.dart';

class PrestadorPageUserVision extends StatelessWidget {
  const PrestadorPageUserVision({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar com título centralizado e botão de voltar
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            // Código para Volta para a página anterior
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detalhes',
          style: TextStyle(
            fontSize: 16,
            color: Colors.purple,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.purple),
                SizedBox(width: 4),
                Text(
                  '3.5',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de portfólio com containers representando imagens
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Scroll horizontal
              child: Row(
                children: [
                  Container(
                    width: 250, // Largura fixa para cada item
                    height: 250,
                    color: Colors.grey[300], // Placeholder para imagem
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 250,
                    height: 250,
                    color: Colors.grey[300], // Placeholder para imagem
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 250,
                    height: 250,
                    color: Colors.grey[300], // Placeholder para imagem
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Informações do prestador
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Placeholder para avatar
                   borderRadius: BorderRadius.circular(12) // Formato circular
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NOME DO PRESTADOR',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    // Nome do prestador
                    Row(
                      children: [
                        Text(
                          'Jean Carlo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.verified, size: 26, color: Colors.purple,)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            // Linha com informações de serviço e valor/hora
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Esfera com ícone e texto "SERVIÇO"
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple[50], // Cor da esfera
                        shape: BoxShape.circle, // Formato circular
                      ),
                      child: Icon(
                        Icons.handyman, // Ícone representando "SERVIÇO"
                        color: Colors.purple,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 8), // Espaço entre a esfera e o texto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SERVIÇO',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Mecânico',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 16), // Espaço entre os dois itens
                // Esfera com ícone e texto "VALOR / HORA"
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple[50], // Cor da esfera
                        shape: BoxShape.circle, // Formato circular
                      ),
                      child: Icon(
                        Icons.attach_money, // Ícone representando "DINHEIRO"
                        color: Colors.purple,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 8), // Espaço entre a esfera e o texto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VALOR / HORA',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '50',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.purple,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              ',00',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Seção de avaliações
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Últimas avaliações: 14',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                // Botão "Ver mais" que direciona para a página de avaliações
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsPage(),
                      ), // Navega para ReviewsPage
                    );
                  },
                  child: Text(
                    'Ver mais',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
            // Lista de avaliações
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Número de avaliações exibidas
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.grey[300], // Placeholder para avatar
                    ),
                    title: Text('José Silvano'),
                    subtitle: Text('Lorem ipsum lorem ipsum lorem ipsum'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.purple, size: 20),
                        SizedBox(width: 4),
                        Text('3'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Botão fixo na parte inferior para solicitar agendamento
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Schedulepage(), // Navega para ReviewsPage
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text(
            'Solicitar agendamento',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
