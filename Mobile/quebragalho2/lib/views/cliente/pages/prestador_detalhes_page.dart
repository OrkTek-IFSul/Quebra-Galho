import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';

class PrestadorDetalhesPage extends StatefulWidget {
  final int id;

  const PrestadorDetalhesPage({
    super.key,
    required this.id,
  });

  @override
  State<PrestadorDetalhesPage> createState() => _PrestadorDetalhesPageState();
}

class _PrestadorDetalhesPageState extends State<PrestadorDetalhesPage> {
  Map<String, dynamic>? prestadorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrestadorDetails();
  }

  Future<void> _fetchPrestadorDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/usuario/homepage/prestador/${widget.id}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          prestadorData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar dados do prestador');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar detalhes do prestador: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Carregando...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (prestadorData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Erro')),
        body: Center(child: Text('Erro ao carregar dados do prestador')),
      );
    }

    final List<dynamic> tags = prestadorData!['tags'] ?? [];
    final List<dynamic> servicos = prestadorData!['servicos'] ?? [];
    final String name = prestadorData!['nome'] ?? '';
    final String descricao = prestadorData!['descricao'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Detalhes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'http://localhost:8080/${prestadorData!['imagemPerfil']}',
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
              children: tags
                  .map((tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag['nome'] ?? '',
                          style: TextStyle(color: Colors.green.shade800),
                        ),
                      ))
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

            // Avaliação média
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text(
                  '${prestadorData!['mediaAvaliacoes']?.toStringAsFixed(1) ?? '0.0'}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Serviços
            Text(
              'Serviços oferecidos:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),

            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: servicos.length,
              itemBuilder: (_, index) {
                final servico = servicos[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(servico['nome'] ?? ''),
                  subtitle: Text(servico['descricao'] ?? ''),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AgendamentoPage(
                          servico: servico['nome'],
                        ),
                      ),
                    );
                  },
                  trailing: Text(
                    'R\$ ${servico['preco']?.toStringAsFixed(2) ?? '0.00'}',
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
