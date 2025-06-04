import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quebragalho2/views/cliente/pages/detalhes_solicitacao_page.dart';
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

  @override
  void initState() {
    super.initState();
    _carregarSolicitacoes();
  }

  String _formatarData(String dataString) {
    final data = DateTime.parse(dataString);
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _carregarSolicitacoes() async {
    try {
      final response = await http.get(
        //ALTERAR ID DO USUARIO NO FINAL DA URL
        Uri.parse('http://192.168.0.155:8080/api/usuario/solicitacoes/2'),
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
            child: ListView.builder(
              itemCount: solicitacoes.length,
              itemBuilder: (context, index) {
                final item = solicitacoes[index];
                return SolicitacaoWidget(
                  nome: item['nome']!,
                  horario: item['horario']!,
                  status: item['status']!,
                  imagemUrl: item['imagem']!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //AO SELECIONAR UMA SOLICITACAO DEVE ENVIAR O ID DO SERVICO
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
