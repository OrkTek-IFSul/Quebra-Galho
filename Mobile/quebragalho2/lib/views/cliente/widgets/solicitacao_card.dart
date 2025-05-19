import 'package:flutter/material.dart';

class SolicitacaoWidget extends StatelessWidget {
  final String nome;
  final String horario;
  final String status;
  final String imagemUrl;
  final VoidCallback onTap;

  const SolicitacaoWidget({
    super.key,
    required this.nome,
    required this.horario,
    required this.status,
    required this.imagemUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // A mágica tá aqui, chefia
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imagemUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Horário: $horario"),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(status, style: const TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
