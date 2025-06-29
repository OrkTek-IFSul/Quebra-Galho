import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/prestador/pages/avaliacoes_page_detalhes.dart';

class ListaAvaliacoesPage extends StatefulWidget {
  final int idPrestador;
  const ListaAvaliacoesPage({Key? key, required this.idPrestador}) : super(key: key);

  @override
  State<ListaAvaliacoesPage> createState() => _ListaAvaliacoesPageState();
}

class _ListaAvaliacoesPageState extends State<ListaAvaliacoesPage> {
  List<dynamic> avaliacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarAvaliacoes();
  }

  Future<void> _carregarAvaliacoes() async {
    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/avaliacoesprestador/${widget.idPrestador}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          avaliacoes = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Avaliações Recebidas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : avaliacoes.isEmpty
              ? const Center(child: Text('Nenhuma avaliação encontrada.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: avaliacoes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final avaliacao = avaliacoes[index];
                    final imagemPerfil = avaliacao['imagemPerfil'];
                    final nomeUsuario = avaliacao['nomeUsuario'] ?? '';
                    final nomeServico = avaliacao['nomeServico'] ?? '';
                    final comentario = avaliacao['comentario'] ?? '';
                    final nota = avaliacao['nota'] ?? 0;
                    final data = avaliacao['data'] ?? '';

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AvaliacaoDetalhesPage(idAvaliacao: avaliacao['idAvaliacao']),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: (imagemPerfil != null && imagemPerfil.isNotEmpty)
                                    ? NetworkImage('https://${ApiConfig.baseUrl}/$imagemPerfil')
                                    : null,
                                backgroundColor: Colors.grey[200],
                                child: (imagemPerfil == null || imagemPerfil.isEmpty)
                                    ? const Icon(Icons.person, color: Colors.grey, size: 32)
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            nomeUsuario,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          data,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      nomeServico,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    if (comentario.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          comentario,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.amber[50],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.star, color: Colors.amber[700], size: 28),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nota.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}