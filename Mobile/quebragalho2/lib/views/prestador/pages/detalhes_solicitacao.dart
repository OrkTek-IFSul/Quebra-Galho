import 'package:flutter/material.dart';

class DetalhesSolicitacaoPage extends StatelessWidget {
  final String nome;
  final String fotoUrl;
  final String servico;
  final String dataHora;
  final double valorTotal;

  const DetalhesSolicitacaoPage({
    super.key,
    required this.nome,
    required this.fotoUrl,
    required this.servico,
    required this.dataHora,
    required this.valorTotal,
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
            Text('Nome do cliente: $nome', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Serviço: $servico', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Data e hora: $dataHora', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Valor total: R\$ $valorTotal', style: const TextStyle(fontSize: 18)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Solicitação confirmada')),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Solicitação recusada')),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Recusar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
