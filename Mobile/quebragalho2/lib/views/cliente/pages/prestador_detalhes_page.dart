import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class PrestadorDetalhesPage extends StatefulWidget {
  final int id;
  final bool isLoggedIn;

  const PrestadorDetalhesPage({
    super.key,
    required this.id,
    required this.isLoggedIn,
  });

  @override
  State<PrestadorDetalhesPage> createState() => _PrestadorDetalhesPageState();
}

class _PrestadorDetalhesPageState extends State<PrestadorDetalhesPage> {
  Map<String, dynamic>? prestadorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrestadorDetails();
  }

  Future<void> _fetchPrestadorDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://${ApiConfig.baseUrl}/api/usuario/homepage/prestador/${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          prestadorData = jsonDecode(utf8.decode(response.bodyBytes));
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar dados do prestador');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar detalhes do prestador: $e');
    }
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData iconData = Icons.star_border;
      Color color = Colors.grey;
      if (i <= rating) {
        iconData = Icons.star;
        color = Colors.amber;
      } else if (i - 0.5 <= rating) {
        iconData = Icons.star_half;
        color = Colors.amber;
      }
      stars.add(Icon(iconData, color: color, size: 20));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }

  Map<String, List<dynamic>> _groupServices(List<dynamic> services) {
    Map<String, List<dynamic>> grouped = {};
    for (var service in services) {
      String key = service['nome'] ?? 'Outros';
      if (grouped[key] == null) {
        grouped[key] = [];
      }
      grouped[key]!.add(service);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (prestadorData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Erro ao carregar dados do prestador')),
      );
    }

    final String imageUrl = prestadorData!['imagemPerfil'] ?? '';
    final String name = prestadorData!['nome'] ?? 'Nome Indisponível';
    final double rating =
        (prestadorData!['mediaAvaliacoes'] as num?)?.toDouble() ?? 0.0;
    final List<dynamic> tags = prestadorData!['tags'] ?? [];
    final String descricao = prestadorData!['descricao'] ?? '';
    final List<dynamic> servicos = prestadorData!['servicos'] ?? [];
    final groupedServices = _groupServices(servicos);

    return Scaffold(
      // AJUSTE APLICADO AQUI
      appBar: AppBar(
        // 1. Centraliza o título
        centerTitle: true,
        // 2. Diminui o tamanho da fonte do título
        title: const Text('Detalhes', style: TextStyle(fontSize: 18.0)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Avaliações',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildRatingStars(rating),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children:
                        tags
                            .take(3)
                            .map(
                              (tag) => Chip(
                                label: Text(tag['nome'] ?? ''),
                                backgroundColor: Colors.grey[200],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Sobre:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            const Text(
              'Selecione um dos serviços para agendar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: groupedServices.keys.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                String groupName = groupedServices.keys.elementAt(index);
                List<dynamic> servicesInGroup = groupedServices[groupName]!;

                return Column(
                  children:
                      servicesInGroup.map((servico) {
                        return InkWell(
                          onTap: () {
                            if (!widget.isLoggedIn) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Atenção'),
                                      content: const Text(
                                        'Você precisa estar logado para agendar um serviço.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(); // Fecha o dialog
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
                                          },
                                          child: const Text('Fazer login'),
                                        ),
                                      ],
                                    ),
                              );
                              return;
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => AgendamentoPage(
                                      servico: servico['nome'],
                                      servicoId: servico['id'],
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        groupName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        servico['descricao'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'R\$ ${servico['preco']?.toStringAsFixed(2) ?? '0.00'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
