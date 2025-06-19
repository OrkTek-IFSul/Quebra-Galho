import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class AvaliacoesPrestadorPage extends StatefulWidget {
  final int idPrestador;
  const AvaliacoesPrestadorPage({super.key, required this.idPrestador});

  @override
  State<AvaliacoesPrestadorPage> createState() => _AvaliacoesPrestadorPageState();
}

class _AvaliacoesPrestadorPageState extends State<AvaliacoesPrestadorPage> {
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
      appBar: AppBar(title: const Text('Avaliações')),
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

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: imagemPerfil != null && imagemPerfil.isNotEmpty
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
                                  Text(
                                    nomeUsuario,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    nomeServico,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    comentario,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    data,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 28),
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
                    );
                  },
                ),
    );
  }
}