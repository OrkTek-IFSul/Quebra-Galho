import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/editar_meus_dados.dart';

class MeusDados extends StatelessWidget {
  const MeusDados({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = ['Cabelo', 'Barba', 'Design'];
    final horarios = ['09:00', '10:00', '11:00', '12:00', '13:00'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditarMeusDados(),
                ),
              );
              // Ação para editar dados
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('João da Silva'),
            const SizedBox(height: 12),

            const Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('(11) 91234-5678'),
            const SizedBox(height: 12),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('joao@email.com'),
            const SizedBox(height: 12),

            const Text('CPF', style: TextStyle(fontWeight: FontWeight.bold)),
            const Text('123.456.789-00'),
            const SizedBox(height: 12),

            const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
            const SizedBox(height: 16),

            const Text('Horários Disponibilizados', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...horarios.map((hora) => Text('• $hora')),
          ],
        ),
      ),
    );
  }
}
