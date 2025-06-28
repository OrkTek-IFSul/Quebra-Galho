import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';
import 'package:quebragalho2/views/cliente/pages/avaliacoes_prestador.dart';
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
  List<Map<String, dynamic>> portfolio = [];

  @override
  void initState() {
    super.initState();
    _fetchPrestadorDetails();
  }

  Future<void> _fetchPrestadorDetails() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://${ApiConfig.baseUrl}/api/prestador/perfil/${widget.id}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final usuario = data['usuario'] ?? {};

        prestadorData = {
          'nome': usuario['nome'] ?? 'Nome não informado',
          'email': usuario['email'] ?? '',
          'telefone': usuario['telefone'] ?? '',
          'descricao': data['descricao'] ?? 'Descrição não informada.',
          'documento': usuario['documento'] ?? '',
          'imagemPerfil': usuario['imagemPerfil'] != null && usuario['imagemPerfil'].toString().isNotEmpty
              ? 'http://${ApiConfig.baseUrl}/${usuario['imagemPerfil']}'
              : null,
          'mediaAvaliacoes': data['mediaAvaliacoes'] ?? 0.0,
          'tags': data['tags'] ?? [],
          'servicos': data['servicos'] ?? [],
        };

        await _carregarPortfolio(widget.id);

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar dados (Status: ${response.statusCode})');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _carregarPortfolio(int id) async {
    final url = 'http://${ApiConfig.baseUrl}/api/portfolio/prestador/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          portfolio = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar portfólio: $e");
    }
  }

  void _abrirImagemFullScreen(int idImagem) {
    final imagemUrl = 'http://${ApiConfig.baseUrl}/api/portfolio/$idImagem/imagem';
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.network(imagemUrl, fit: BoxFit.contain),
        ),
      ),
    );
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
      grouped.putIfAbsent(key, () => []).add(service);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = prestadorData!['nome'] ?? 'Prestador';
    final imageUrl = prestadorData!['imagemPerfil'];
    final rating = (prestadorData!['mediaAvaliacoes'] as num?)?.toDouble() ?? 0.0;
    final tags = prestadorData!['tags'] ?? [];
    final descricao = prestadorData!['descricao'] ?? '';
    final servicos = prestadorData!['servicos'] ?? [];
    final groupedServices = _groupServices(servicos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Perfil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl)
                        : null,
                    child: imageUrl == null
                        ? Text(name[0], style: const TextStyle(fontSize: 40))
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AvaliacoesPrestadorPage(idPrestador: widget.id)),
                    ),
                    child: _buildRatingStars(rating),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: tags.map<Widget>(
                      (tag) => Chip(label: Text(tag['nome'] ?? '')),
                    ).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Descrição
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Sobre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text(descricao),

            const SizedBox(height: 24),

            // Portfólio
            if (portfolio.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Portfólio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: portfolio.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    final imagem = portfolio[index];
                    final url = 'http://${ApiConfig.baseUrl}${imagem['imagemUrl']}';
                    return GestureDetector(
                      onTap: () => _abrirImagemFullScreen(imagem['id']),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Divider(),

            // Lista de serviços
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Serviços', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedServices.length,
              itemBuilder: (_, i) {
                final nome = groupedServices.keys.elementAt(i);
                final servicosGrupo = groupedServices[nome]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: servicosGrupo.map((servico) {
                    return ListTile(
                      title: Text(servico['nome']),
                      subtitle: Text(servico['descricao'] ?? ''),
                      trailing: Text('R\$ ${servico['preco']?.toStringAsFixed(2) ?? '0.00'}'),
                      onTap: () {
                        if (!widget.isLoggedIn) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Atenção'),
                              content: const Text('Você precisa estar logado para agendar.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                                  },
                                  child: const Text('Fazer login'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AgendamentoPage(
                              servico: servico['nome'],
                              servicoId: servico['id'],
                              prestadorId: widget.id,
                            ),
                          ),
                        );
                      },
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
