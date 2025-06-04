import 'package:flutter/material.dart';
import 'detalhes_solicitacao_page.dart';

class MinhasSolicitacoesPage extends StatelessWidget {
  MinhasSolicitacoesPage({super.key});

  final List<Map<String, String>> solicitacoes = [
    {
      'nome': 'Pedro Silva',
      'horario': '08:00 - 10:00',
      'status': 'Confirmado',
      'imagemUrl': '...jpg',
      'valor': '60.00',
    },
    {
      'nome': 'Maria Perez',
      'horario': '16:00 - 17:30',
      'status': 'Pendente',
      'imagemUrl': '...jpg',
      'valor': '45.00',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Solicitações')),
      body: ListView.builder(
        itemCount: solicitacoes.length,
        itemBuilder: (context, index) {
          final solicitacao = solicitacoes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(solicitacao['imagemUrl']!),
              ),
              title: Text(solicitacao['nome']!),
              subtitle: Text('Horário: ${solicitacao['horario']}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(solicitacao['status']!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  solicitacao['status']!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesSolicitacaoPage(
                      nome: solicitacao['nome']!,
                      horario: solicitacao['horario']!,
                      status: solicitacao['status']!,
                      imagemUrl: solicitacao['imagemUrl']!,
                      valor: solicitacao['valor']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
