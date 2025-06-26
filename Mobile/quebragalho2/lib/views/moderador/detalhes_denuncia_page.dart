import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class DetalhesDenunciaPage extends StatefulWidget {
  final Map<String, dynamic> denuncia;

  const DetalhesDenunciaPage({super.key, required this.denuncia});

  @override
  State<DetalhesDenunciaPage> createState() => _DetalhesDenunciaPageState();
}

class _DetalhesDenunciaPageState extends State<DetalhesDenunciaPage> {
  Map<String, dynamic>? prestadorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPrestador();
  }

  Future<void> _carregarPrestador() async {
    final id = widget.denuncia['denunciadoId'];
    try {
      final uri = Uri.parse(
        'http://${ApiConfig.baseUrl}/api/prestador/perfil/$id',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        final usuario = data['usuario'] ?? {};
        setState(() {
          prestadorData = {
            'nome': usuario['nome'],
            'email': usuario['email'],
            'telefone': usuario['telefone'],
            'documento': usuario['documento'],
            'imagemPerfil':
                usuario['imagemPerfil'] != null
                    ? 'http://${ApiConfig.baseUrl}/${usuario['imagemPerfil']}'
                    : null,
            'descricao': data['descricao'] ?? '',
            'tags': data['tags'] ?? [],
            'servicos': data['servicos'] ?? [],
          };
          isLoading = false;
        });
      } else {
        print('Erro ao carregar prestador: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Erro ao carregar prestador: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _atualizarStatusDenuncia(bool aceitar) async {
    final id = widget.denuncia['denunciaId'];
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/${aceitar ? "aceitarDenuncia" : "recusarDenuncia"}/$id',
    );

    try {
      final response = await http.put(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Denúncia ${aceitar ? "aceita" : "recusada"} com sucesso!',
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Erro: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar denúncia: $e')));
    }
  }

  Widget _buildCampo(String label, String? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor ?? '---')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final denuncia = widget.denuncia;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Denúncia')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📄 Dados da Denúncia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildCampo('ID', '${denuncia['denunciaId']}'),
                    _buildCampo('Tipo', denuncia['tipo']),
                    _buildCampo('Motivo', denuncia['motivo']),
                    _buildCampo(
                      'Conteúdo Denunciado',
                      denuncia['conteudoDenunciado'],
                    ),
                    _buildCampo('Denunciante', denuncia['nomeDenunciante']),
                    _buildCampo('Denunciado', denuncia['nomeDenunciado']),
                    _buildCampo(
                      'Status',
                      denuncia['status'] == null
                          ? 'Pendente'
                          : '${denuncia['status']}',
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const Text(
                      '👤 Prestador Denunciado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (prestadorData != null) ...[
                      if (prestadorData!['imagemPerfil'] != null)
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              prestadorData!['imagemPerfil'],
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      _buildCampo('Nome', prestadorData!['nome']),
                      _buildCampo('Email', prestadorData!['email']),
                      _buildCampo('Telefone', prestadorData!['telefone']),
                      _buildCampo('CPF', prestadorData!['documento']),
                      _buildCampo('Descrição', prestadorData!['descricao']),
                      const SizedBox(height: 10),
                      const Text('Tags:'),
                      Wrap(
                        spacing: 6,
                        children:
                            (prestadorData!['tags'] as List).map<Widget>((tag) {
                              return Chip(label: Text(tag['nome']));
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Serviços:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...((prestadorData!['servicos'] as List).map((s) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(s['nome'] ?? ''),
                          subtitle: Text(s['descricao'] ?? ''),
                          trailing: Text(
                            'R\$ ${s['preco']?.toStringAsFixed(2) ?? "0.00"}',
                          ),
                        );
                      })),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _atualizarStatusDenuncia(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Aceitar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _atualizarStatusDenuncia(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Recusar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
