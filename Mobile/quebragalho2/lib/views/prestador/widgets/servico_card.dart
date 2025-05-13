
import 'package:flutter/material.dart';

class ServicoCard extends StatelessWidget {
  final String nome;
  final double valor;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ServicoCard({
    super.key,
    required this.nome,
    required this.valor,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(nome),
        subtitle: Text('R\$ ${valor.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
