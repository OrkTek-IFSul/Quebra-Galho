import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/detalhes_solicitacao_page.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
import 'package:quebragalho2/views/cliente/widgets/solicitacao_card.dart';

class MinhasSolicitacoesPage extends StatefulWidget {
  const MinhasSolicitacoesPage({super.key});

  @override
  State<MinhasSolicitacoesPage> createState() => _MinhasSolicitacoesPageState();
}

class _MinhasSolicitacoesPageState extends State<MinhasSolicitacoesPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  List<dynamic> _solicitacoes = [];
  List<dynamic> _solicitacoesFiltradas = [];
  int? _usuarioId;

  @override
  void initState() {
    super.initState();

    // Obter o usuário (sem await dentro de Future) e depois carregar as solicitações
    obterIdUsuario().then((id) {
      if (!mounted) return;
      setState(() {
        _usuarioId = id;
      });
      _carregarSolicitacoes();
    });
  }

  String _formatarData(String dataString) {
    final data = DateTime.parse(dataString);
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _carregarSolicitacoes() async {
    if (_usuarioId == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não identificado.')),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/solicitacoes/$_usuarioId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _solicitacoes = json.decode(response.body);
          _solicitacoesFiltradas = _solicitacoes;
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar solicitações');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _filtrarSolicitacoes(String query) {
    setState(() {
      if (query.isEmpty) {
        _solicitacoesFiltradas = _solicitacoes;
      } else {
        _solicitacoesFiltradas = _solicitacoes.where((item) {
          final nomePrestador = item['nome_prestador'].toString().toLowerCase();
          return nomePrestador.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Solicitações")),
      body: Column(
        children: [
          /// Barra de Pesquisa
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filtrarSolicitacoes,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _solicitacoesFiltradas.length,
                    itemBuilder: (context, index) {
                      final item = _solicitacoesFiltradas[index];
                      return SolicitacaoWidget(
                        nome: item['nome']!,
                        horario: item['horario']!,
                        status: item['status_aceito']!,
                        imagemUrl: item['imagem']!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalhesSolicitacaoPage(agendamentoId: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
