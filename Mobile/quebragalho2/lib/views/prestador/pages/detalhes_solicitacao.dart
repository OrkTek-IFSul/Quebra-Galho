import 'package:flutter/material.dart';

class DetalhesSolicitacaoPage extends StatelessWidget {
  final String nome;
  final String fotoUrl;
  final String servico;
  final String dataHora;
  final double valorTotal;
  final int idAgendamento;

  const DetalhesSolicitacaoPage({
    super.key,
    required this.nome,
    required this.fotoUrl,
    required this.servico,
    required this.dataHora,
    required this.valorTotal,
    required this.idAgendamento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Solicitação')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto do cliente
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(fotoUrl),
              ),
            ),
            const SizedBox(height: 20),

            // Informações do serviço
            Text(
              'Nome do cliente: $nome',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Serviço: $servico',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Data e hora: $dataHora',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Valor total: R\$ ${valorTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
