import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MeusDados extends StatefulWidget {
  const MeusDados({super.key});

  @override
  State<MeusDados> createState() => _MeusDadosState();
}

class _MeusDadosState extends State<MeusDados> {
  Map<String, dynamic>? usuario;
  Map<String, dynamic>? prestador;
  List<String> tags = [];
  bool isLoading = true;

  final int usuarioId = 1;
  final int prestadorId = 1;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    try {
      final usuarioResp = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/usuario/perfil/$usuarioId'),
      );

      final prestadorResp = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/prestador/perfil/$prestadorId'),
      );

      final tagPrestadorResp = await http.get(
        Uri.parse(
          'http://10.0.2.2:8080/api/tag-prestador/prestador/$prestadorId',
        ),
      );

      List<String> tagNomes = [];

      if (tagPrestadorResp.statusCode == 200) {
        final List tagIds = jsonDecode(tagPrestadorResp.body); // [1, 2, 3]

        for (var idTag in tagIds) {
          final tagResp = await http.get(
            Uri.parse('http://10.0.2.2:8080/api/tags/$idTag'),
          );

          if (tagResp.statusCode == 200) {
            final tagData = jsonDecode(tagResp.body);
            tagNomes.add(tagData['nome']);
          }
        }
      }

      setState(() {
        usuario = jsonDecode(usuarioResp.body);
        prestador = jsonDecode(prestadorResp.body);
        tags = tagNomes;
        isLoading = false;
      });
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (usuario == null || prestador == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar dados.')),
      );
    }

    final horarios = [
      prestador!['data_hora_inicio'],
      prestador!['data_hora_fim'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navegar para edição
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario!['nome']),
            const SizedBox(height: 12),

            const Text(
              'Telefone',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(usuario!['telefone']),
            const SizedBox(height: 12),

            const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario!['email']),
            const SizedBox(height: 12),

            const Text('CPF', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(usuario!['documento']),
            const SizedBox(height: 12),

            const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((nome) => Chip(label: Text(nome))).toList(),
            ),
            const SizedBox(height: 16),

            const Text(
              'Horários Disponibilizados',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...horarios.map((h) => Text('• $h')),
          ],
        ),
      ),
    );
  }
}
