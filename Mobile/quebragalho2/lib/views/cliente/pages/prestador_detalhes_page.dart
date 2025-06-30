import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/agendamento_page.dart';
import 'package:quebragalho2/views/cliente/pages/avaliacoes_prestador.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/perfil/${widget.id}'),
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
              ? 'https://${ApiConfig.baseUrl}/${usuario['imagemPerfil']}'
              : null,
          'mediaAvaliacoes': data['mediaAvaliacoes'] ?? 0.0,
          'tags': data['tags'] ?? [],
          'servicos': data['servicos'] ?? [],
        };

        await _carregarPortfolio(widget.id);

        setState(() => isLoading = false);
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
    final url = 'https://${ApiConfig.baseUrl}/api/portfolio/prestador/$id';
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
    final imagemUrl = 'https://${ApiConfig.baseUrl}/api/portfolio/$idImagem/imagem';
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.network(imagemUrl, fit: BoxFit.contain),
        ),
      ),
    );
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
                items: tipos
                    .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (value) => tipoSelecionado = value,
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

    final prefs = await SharedPreferences.getInstance();
    final denuncianteId = prefs.getInt('usuario_id');

    final body = {
      "tipo": tipoSelecionado,
      "motivo": motivoController.text,
      "idConteudoDenunciado": widget.id,
      "denunciante": denuncianteId,
      "denunciado": widget.id,
    };

    final response = await http.post(
      Uri.parse('https://${ApiConfig.baseUrl}/api/denuncia'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.statusCode == 200 || response.statusCode == 201
              ? 'Denúncia enviada com sucesso!'
              : 'Erro ao denunciar: ${response.statusCode}\n${response.body}',
        ),
      ),
    );
  },
),

          ],
        );
      },
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final index = i + 1;
        if (index <= rating) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index - 0.5 <= rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 20);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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

    final String name = prestadorData!['nome'];
    final String? imageUrl = prestadorData!['imagemPerfil'];
    final double rating = (prestadorData!['mediaAvaliacoes'] as num?)?.toDouble() ?? 0.0;
    final List<dynamic> tags = prestadorData!['tags'] ?? [];
    final String descricao = prestadorData!['descricao'];
    final List<dynamic> servicos = prestadorData!['servicos'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl == null
                        ? Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 40))
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Sobre', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Text(descricao),
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
                    final url = 'https://${ApiConfig.baseUrl}${imagem['imagemUrl']}';
                    return GestureDetector(
                      onTap: () => _abrirImagemFullScreen(imagem['id']),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          url,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Serviços', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: servicos.length,
              itemBuilder: (_, index) {
                final servico = servicos[index];
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => LoginPage()),
                                );
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
