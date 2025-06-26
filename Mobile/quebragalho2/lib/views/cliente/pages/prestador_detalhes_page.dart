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

  @override
  void initState() {
    super.initState();
    _fetchPrestadorDetails();
  }

  // CORREÇÃO 1: Removido o método duplicado `_carregarDadosPrestador`.
  // Apenas este método é necessário e está sendo chamado no initState.
  Future<void> _fetchPrestadorDetails() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
          // Mantive a URL com http:// como no seu código original.
          // Se sua API usa https, lembre-se de ajustar aqui.
          'https://${ApiConfig.baseUrl}/api/prestador/perfil/${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        // Usando utf8.decode para garantir a decodificação correta de caracteres especiais (acentos)
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        final usuario = data['usuario'] ?? {};
        prestadorData = {
          'nome': usuario['nome'] ?? 'Nome não informado',
          'email': usuario['email'] ?? '',
          'telefone': usuario['telefone'] ?? '',
          'descricao': data['descricao'] ?? 'Descrição não informada.',
          'documento': usuario['documento'] ?? '',
          'imagemPerfil':
              usuario['imagemPerfil'] != null &&
                      usuario['imagemPerfil'].toString().isNotEmpty
                  ? 'https://${ApiConfig.baseUrl}/' + usuario['imagemPerfil']
                  : null,
          'mediaAvaliacoes': data['mediaAvaliacoes'] ?? 0.0,
          'tags': data['tags'] ?? [],
          'servicos': data['servicos'] ?? [],
        };

        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception(
          'Falha ao carregar dados do prestador (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Adiciona um feedback mais claro no console e na tela
      print('Erro ao carregar detalhes do prestador: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
    }
  }

  void _mostrarDialogoDenuncia(BuildContext context) {
    final List<String> tipos = ['Conta', 'Resposta', 'Avaliação'];
    String? tipoSelecionado;
    TextEditingController motivoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Denunciar Prestador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo'),
                items:
                    tipos.map((tipo) {
                      return DropdownMenuItem(value: tipo, child: Text(tipo));
                    }).toList(),
                onChanged: (value) {
                  tipoSelecionado = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: motivoController,
                decoration: const InputDecoration(labelText: 'Motivo'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Enviar'),
              onPressed: () async {
                if (tipoSelecionado == null || motivoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos')),
                  );
                  return;
                }

                // Exemplo de IDs (substitua conforme seu app)
                final denuncianteId = 5; // ID do usuário logado
                final denunciadoId = widget.id;
                final idConteudoDenunciado = widget.id;

                final body = {
                  "tipo": tipoSelecionado,
                  "motivo": motivoController.text,
                  "idConteudoDenunciado": idConteudoDenunciado,
                  "denunciante": denuncianteId,
                  "denunciado": denunciadoId,
                };

                final response = await http.post(
                  Uri.parse('https://${ApiConfig.baseUrl}/api/denuncia'),
                  headers: {"Content-Type": "application/json"},
                  body: jsonEncode(body),
                );

                Navigator.of(context).pop();

                if (response.statusCode == 200 || response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Denúncia enviada com sucesso!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erro ao denunciar: ${response.statusCode}',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
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

  // CORREÇÃO 2: Ajuste na lógica de agrupamento de serviços.
  // Agora ele agrupa corretamente pelo nome de cada serviço.
  Map<String, List<dynamic>> _groupServices(List<dynamic> services) {
    Map<String, List<dynamic>> grouped = {};
    for (var service in services) {
      // O nome do serviço está diretamente no objeto 'service', não em 'service['servicos']'
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Erro ao carregar dados do prestador.'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _fetchPrestadorDetails,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    // CORREÇÃO 3: Acesso correto aos dados no mapa `prestadorData`.
    final String imageUrl = prestadorData!['imagemPerfil'] ?? '';
    // O nome agora é acessado diretamente de 'nome', e não de 'usuario['nome']'.
    final String name = prestadorData!['nome'] ?? 'Nome Indisponível';
    final double rating =
        (prestadorData!['mediaAvaliacoes'] as num?)?.toDouble() ?? 0.0;
    final List<dynamic> tags = prestadorData!['tags'] ?? [];
    final String descricao = prestadorData!['descricao'] ?? '';
    final List<dynamic> servicos = prestadorData!['servicos'] ?? [];
    final groupedServices = _groupServices(servicos);

    // O restante do seu layout é mantido exatamente como estava.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                    child:
                        imageUrl.isNotEmpty
                            ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            )
                            : Center(
                              // Fallback caso a URL da imagem esteja vazia
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AvaliacoesPrestadorPage(
                                idPrestador: widget.id,
                              ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center, // Centraliza a linha de avaliação
                      children: [
                        const Text(
                          'Avaliações',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildRatingStars(rating),
                      ],
                    ),
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
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _mostrarDialogoDenuncia(context),
              icon: const Icon(Icons.report_problem_outlined),
              label: const Text('Denunciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
              ),
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

                // Mapeia cada serviço dentro do grupo para um InkWell
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Navigator.of(context).pop();
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) => LoginPage(),
                                              ),
                                            );
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
                                      // Acessando os dados do serviço corretamente
                                      servico:
                                          servico['nome'] ?? 'Serviço sem nome',
                                      servicoId: servico['id'],
                                      prestadorId:
                                          widget
                                              .id, // Passando o ID do prestador
                                      // Passando o ID do prestador
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
                                        // Usando o nome do serviço diretamente
                                        servico['nome'] ?? 'Serviço',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (servico['descricao'] != null &&
                                          servico['descricao'].isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Text(
                                            servico['descricao'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
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
