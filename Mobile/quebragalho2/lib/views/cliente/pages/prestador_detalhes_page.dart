import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';

class PrestadorDetalhesPage extends StatelessWidget {
  final String name;
  final List<String> categories;
  final String imageUrl;
  final String descricao;
  final List<Map<String, dynamic>> servicos; // nome e preço

  const PrestadorDetalhesPage({super.key, 
    required this.name,
    required this.categories,
    required this.imageUrl,
    required this.descricao,
    required this.servicos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),

            // Nome
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 8,
              children:
                  categories
                      .map(
                        (cat) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(color: Colors.green.shade800),
                          ),
                        ),
                      )
                      .toList(),
            ),

            SizedBox(height: 16),

            // Descrição
            Text(
              'Sobre:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(descricao, style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),

            // Serviços
            Text(
              'Serviços oferecidos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),

            ListView.builder(
              physics:
                  NeverScrollableScrollPhysics(), // pra scroll não bugar com SingleChildScrollView
              shrinkWrap: true,
              itemCount: servicos.length,
              itemBuilder: (_, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(servicos[index]['nome']),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => AgendamentoPage(
                              servico: servicos[index]['nome'],
                            ),
                      ),
                    );
                  },
                  trailing: Text(
                    'R\$ ${servicos[index]['preco'].toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
