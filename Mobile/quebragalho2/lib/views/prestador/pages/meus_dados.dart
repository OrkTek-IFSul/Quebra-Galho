import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/prestador/pages/editar_meus_dados.dart';

// O import abaixo não é usado diretamente neste widget, mas foi mantido
// conforme o arquivo original.
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

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

    // Esta função permanece inalterada
    final usuarioId = await obterIdUsuario(); // método já existente
    final prestadorId = await obterIdPrestador(); // supondo que exista este método

    if (usuarioId == null || prestadorId == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        idUsuario = usuarioId;
        idPrestador = prestadorId;
      });
    }


    await carregarDados();
  }

  Future<void> carregarDados() async {
    // Esta função permanece inalterada
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

        final usuarioJson = jsonDecode(utf8.decode(usuarioResp.bodyBytes));
        final prestadorJson = jsonDecode(utf8.decode(prestadorResp.bodyBytes));
        final List tagIds = jsonDecode(utf8.decode(tagPrestadorResp.bodyBytes));


        List<String> tagNomes = [];

        for (var idTag in tagIds) {
          final tagResp = await http.get(
            Uri.parse('https://${ApiConfig.baseUrl}/api/tags/$idTag'),
          );

          if (tagResp.statusCode == 200) {
            final tagData = jsonDecode(utf8.decode(tagResp.bodyBytes));
            tagNomes.add(tagData['nome']);
          }
        }


        if (mounted) {
          setState(() {
            usuario = jsonDecode(usuarioResp.body);
            prestador = jsonDecode(prestadorResp.body);
            tags = tagNomes;
            isLoading = false;
          });
        }

      } else {
        throw Exception('Erro nas respostas: '
            'Usuário(${usuarioResp.statusCode}), '
            'Prestador(${prestadorResp.statusCode}), '
            'Tags(${tagPrestadorResp.statusCode})');
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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

    if (usuario == null || prestador == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meus Dados')),
        body: const Center(child: Text('Erro ao carregar dados.')),
      );
    }

    final String horarioAtendimento = (prestador!['data_hora_inicio'] != null && prestador!['data_hora_fim'] != null)
        ? '${prestador!['data_hora_inicio']} - ${prestador!['data_hora_fim']}'
        : 'Horário não definido';

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar reintroduzido conforme solicitado
      appBar: AppBar(
        title: const Text('Meus Dados', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar Dados',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditarMeusDados()),
              ).then((_) {
                setState(() => isLoading = true);
                carregarDados(); // Atualiza ao voltar
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtítulo
              Center(
                child: Text(
                  'Essas são as suas informações que os clientes poderão acessar em seu perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 40),

              // Seção de Informações do Usuário
              Text('Nome', style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                prestador!['usuario']['nome'] ?? 'Não informado',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 28),

              Text('Telefone', style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                prestador!['usuario']['telefone'] ?? 'Não informado',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 28),

              Text('Email', style: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                prestador!['usuario']['email'] ?? 'Não informado',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 28),

              // Divisor
              const Divider(thickness: 1, height: 40),

              // Seção de Tags
              Text('Tags / Categorias', style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: tags.map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(color: Colors.black87)),
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      )).toList(),
                )
              else
                const Text('Nenhuma tag cadastrada.', style: TextStyle(color: Color.fromARGB(195, 0, 0, 0), fontSize: 18)),
              const SizedBox(height: 32),

              // Seção de Horário
              Text('Horário de Atendimento', style: TextStyle(fontSize: 18, color:  Color.fromARGB(195, 0, 0, 0), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                horarioAtendimento,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}