import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
import 'package:quebragalho2/views/prestador/pages/editar_meus_dados.dart';

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
  int? idUsuario;
  int? idPrestador;

  @override
  void initState() {
    super.initState();
    inicializarDados();
  }

  Future<void> inicializarDados() async {
    final usuarioId = await obterIdUsuario();        // método já existente
    final prestadorId = await obterIdPrestador();    // supondo que exista este método
    
    if (usuarioId == null || prestadorId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    setState(() {
      idUsuario = usuarioId;
      idPrestador = prestadorId;
    });
    
    await carregarDados();
  }

  Future<void> carregarDados() async {
    if (idUsuario == null || idPrestador == null) return;

    try {
      final usuarioResp = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$idUsuario'),
      );

      final prestadorResp = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/perfil/$idPrestador'),
      );

      final tagPrestadorResp = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/tag-prestador/prestador/$idPrestador'),
      );

      if (usuarioResp.statusCode == 200 &&
          prestadorResp.statusCode == 200 &&
          tagPrestadorResp.statusCode == 200) {
        final List tagIds = jsonDecode(tagPrestadorResp.body);

        List<String> tagNomes = [];

        for (var idTag in tagIds) {
          final tagResp = await http.get(
            Uri.parse('https://${ApiConfig.baseUrl}/api/tags/$idTag'),
          );

          if (tagResp.statusCode == 200) {
            final tagData = jsonDecode(tagResp.body);
            tagNomes.add(tagData['nome']);
          }
        }

        setState(() {
          usuario = jsonDecode(usuarioResp.body);
          prestador = jsonDecode(prestadorResp.body);
          tags = tagNomes;
          isLoading = false;
        });
      } else {
        throw Exception('Erro nas respostas: '
            'Usuário(${usuarioResp.statusCode}), '
            'Prestador(${prestadorResp.statusCode}), '
            'Tags(${tagPrestadorResp.statusCode})');
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditarMeusDados()),
              );
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

            const Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold)),
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

            const Text('Horários Disponibilizados', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...horarios.where((h) => h != null).map((h) => Text('• $h')),
          ],
        ),
      ),
    );
  }
}
