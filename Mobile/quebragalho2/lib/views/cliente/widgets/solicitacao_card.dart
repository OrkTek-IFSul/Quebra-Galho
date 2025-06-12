import 'package:flutter/material.dart';

class SolicitacaoWidget extends StatelessWidget {
  final String nome;
  final String horario;
  final String statusServico;
  final String statusAceito;
  final String idAgendamento;
  final VoidCallback onTap;

  const SolicitacaoWidget({
    super.key,
    required this.nome,
    required this.horario,
    required this.statusServico,
    required this.statusAceito,
    required this.idAgendamento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Prestador: $nome", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Horário: $horario"),
            Text("Status Serviço: $statusServico"),
            Text("Status Aceito: $statusAceito"),
          ]
        ),
      ),
    );
  }
}
