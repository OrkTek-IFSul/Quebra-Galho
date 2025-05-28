import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quebragalho2/views/prestador/pages/editar_meus_dados.dart';

class MeusDados extends StatefulWidget {
  const MeusDados({super.key});

  @override
  State<MeusDados> createState() => _MeusDadosState();
}

class _MeusDadosState extends State<MeusDados> {
  bool isLoading = true;
  Map<String, dynamic>? prestadorData;

  @override
  void initState() {
    super.initState();
    _fetchPrestadorData();
  }

  Future<void> _fetchPrestadorData() async {
    try {
      final response = await http.get(
        //Alterar id no final da URL de acordo com o usuário
        Uri.parse('http://localhost:8080/api/prestador/perfil/2'),
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
      print('Erro ao carregar dados: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Dados')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (prestadorData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Dados')),
        body: const Center(child: Text('Erro ao carregar dados')),
      );
    }

    final usuario = prestadorData!['usuario'];
    final tags = (prestadorData!['tags'] as List)
        .map((tag) => tag['nome'].toString())
        .toList();

    // Format working hours
    final horarioInicio = DateTime.parse(prestadorData!['horarioInicio']);
    final horarioFim = DateTime.parse(prestadorData!['horarioFim']);
    final horarios = '${horarioInicio.hour}:00 às ${horarioFim.hour}:00';

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
                  builder: (context) => EditarMeusDados(
                  ),
                ),
              ).then((_) => _fetchPrestadorData());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario['nome']),
            const SizedBox(height: 12),

            const Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario['telefone']),
            const SizedBox(height: 12),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario['email']),
            const SizedBox(height: 12),

            const Text('CPF', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario['documento']),
            const SizedBox(height: 12),

            const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(prestadorData!['descricao']),
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

            const Text('Horário de Trabalho', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('• $horarios'),
          ],
        ),
      ),
    );
  }
}
