import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/prestador/pages/editar_meus_dados.dart';
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
    final usuarioId = await obterIdUsuario();
    final prestadorId = await obterIdPrestador();

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
            usuario = usuarioJson;
            prestador = prestadorJson;
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

  String formatarTelefone(String telefone) {
    final numeros = telefone.replaceAll(RegExp(r'\D'), '');
    if (numeros.length == 11) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7)}';
    } else if (numeros.length == 10) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6)}';
    }
    return telefone;
  }

  String formatarDocumento(String documento) {
    final numeros = documento.replaceAll(RegExp(r'\D'), '');

    if (numeros.length == 11) {
      // CPF: 000.000.000-00
      return '${numeros.substring(0, 3)}.${numeros.substring(3, 6)}.${numeros.substring(6, 9)}-${numeros.substring(9)}';
    } else if (numeros.length == 14) {
      // CNPJ: 00.000.000/0000-00
      return '${numeros.substring(0, 2)}.${numeros.substring(2, 5)}.${numeros.substring(5, 8)}/${numeros.substring(8, 12)}-${numeros.substring(12)}';
    }
    return documento; // sem formatação se tamanho não for 11 nem 14
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('Meus Dados', 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),)),
        body: const Center(child: Text('Erro ao carregar dados.')),
      );
    }

    final String horarioAtendimento;
    if (prestador!['horarioInicio'] != null && prestador!['horarioFim'] != null) {
      final inicio = DateTime.parse(prestador!['horarioInicio']);
      final fim = DateTime.parse(prestador!['horarioFim']);
      final formatador = DateFormat.Hm(); // formato 24h, ex: 14:30
      horarioAtendimento = '${formatador.format(inicio)} - ${formatador.format(fim)}';
    } else {
      horarioAtendimento = 'Horário não definido';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meus Dados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                MaterialPageRoute(
                  builder: (context) => EditarMeusDados(
                    nome: prestador!['usuario']['nome'] ?? '',
                    telefone: prestador!['usuario']['telefone'] ?? '',
                    email: prestador!['usuario']['email'] ?? '',
                    documento: prestador!['usuario']['documento'] ?? '',
                    descricao: prestador!['descricao'] ?? '',
                    horarioInicio: prestador!['horarioInicio'],
                    horarioFim: prestador!['horarioFim'],
                  ),
                ),
              ).then((_) {
                setState(() => isLoading = true);
                carregarDados();
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
              Center(
                child: Text(
                  'Essas são as suas informações que os clientes poderão acessar em seu perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 40),

              // Nome
              Text('Nome', style: _labelStyle()),
              const SizedBox(height: 4),
              Text(prestador!['usuario']['nome'] ?? 'Não informado', style: _valueStyle()),
              const SizedBox(height: 28),

              // Telefone
              Text('Telefone', style: _labelStyle()),
              const SizedBox(height: 4),
              Text(
                prestador!['usuario']['telefone']?.isNotEmpty == true
                    ? formatarTelefone(prestador!['usuario']['telefone'])
                    : 'Não informado',
                style: _valueStyle(),
              ),
              const SizedBox(height: 28),

              // Email
              Text('Email', style: _labelStyle()),
              const SizedBox(height: 4),
              Text(prestador!['usuario']['email'] ?? 'Não informado', style: _valueStyle()),
              const SizedBox(height: 28),

              // Documento
              Text('Documento', style: _labelStyle()),
              const SizedBox(height: 4),
              Text(
                prestador!['usuario']['documento']?.isNotEmpty == true
                    ? formatarDocumento(prestador!['usuario']['documento'])
                    : 'Não informado',
                style: _valueStyle(),
              ),
              const SizedBox(height: 28),

              // Descrição
              Text('Descrição', style: _labelStyle()),
              const SizedBox(height: 4),
              Text(
                prestador!['descricao']?.isNotEmpty == true
                    ? prestador!['descricao']
                    : 'Não informado',
                style: _valueStyle(),
              ),
              const SizedBox(height: 28),

              const Divider(thickness: 1, height: 40),

              // Tags
              Text('Tags / Categorias', style: _labelStyle(fontSize: 18)),
              const SizedBox(height: 16),
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: tags
                      .map((tag) => Chip(
                            label: Text(tag, style: const TextStyle(color: Colors.black87)),
                            backgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ))
                      .toList(),
                )
              else
                const Text('Nenhuma tag cadastrada.',
                    style: TextStyle(color: Colors.black54, fontSize: 18)),
              const SizedBox(height: 32),

              // Horário
              Text('Horário de Atendimento', style: _labelStyle(fontSize: 18, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(horarioAtendimento, style: _valueStyle()),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle({double fontSize = 20, Color color = Colors.black}) {
    return TextStyle(fontSize: fontSize, color: color, fontWeight: FontWeight.bold);
  }

  TextStyle _valueStyle() {
    return const TextStyle(fontSize: 18, color: Colors.black87);
  }
}
