import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class AvaliacaoDetalhesPage extends StatefulWidget {
  final int idAvaliacao;
  const AvaliacaoDetalhesPage({Key? key, required this.idAvaliacao}) : super(key: key);

  @override
  State<AvaliacaoDetalhesPage> createState() => _AvaliacaoDetalhesPageState();
}

class _AvaliacaoDetalhesPageState extends State<AvaliacaoDetalhesPage> {
  Map<String, dynamic>? avaliacao;
  bool isLoading = true;
  final TextEditingController _respostaController = TextEditingController();
  bool enviandoResposta = false;

  @override
  void initState() {
    super.initState();
    _carregarAvaliacao();
  }

  Future<void> _carregarAvaliacao() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/avaliacoesprestador/avaliacao/${widget.idAvaliacao}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          avaliacao = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _enviarResposta() async {
    if (_respostaController.text.trim().isEmpty) return;
    setState(() => enviandoResposta = true);
    try {
      final response = await http.post(
        Uri.parse('https://${ApiConfig.baseUrl}/api/avaliacoesprestador/${widget.idAvaliacao}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'resposta': _respostaController.text.trim()}),
      );
      if (response.statusCode == 200) {
        await _carregarAvaliacao();
        _respostaController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resposta enviada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar resposta: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar resposta: $e')),
      );
    }
    setState(() => enviandoResposta = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Avaliação')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : avaliacao == null
              ? const Center(child: Text('Não foi possível carregar a avaliação.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Usuário e nota
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: (avaliacao!['imagemPerfil'] != null && avaliacao!['imagemPerfil'].toString().isNotEmpty)
                                ? NetworkImage('https://${ApiConfig.baseUrl}/${avaliacao!['imagemPerfil']}')
                                : null,
                            backgroundColor: Colors.grey[200],
                            child: (avaliacao!['imagemPerfil'] == null || avaliacao!['imagemPerfil'].toString().isEmpty)
                                ? const Icon(Icons.person, color: Colors.grey, size: 36)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  avaliacao!['nomeUsuario'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  avaliacao!['nomeServico'] ?? '',
                                  style: TextStyle(fontSize: 15, color: theme.primaryColorDark),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  avaliacao!['data'] ?? '',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(Icons.star, color: Colors.amber[700], size: 30),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (avaliacao!['nota'] ?? '').toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Comentário do usuário
                      if ((avaliacao!['comentario'] ?? '').toString().isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            avaliacao!['comentario'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      const SizedBox(height: 24),
                      // Resposta do prestador ou campo para responder
                      if (avaliacao!['resposta'] != null) ...[
                        const Text(
                          "Sua resposta:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: (avaliacao!['resposta']['imagemPerfil'] != null &&
                                      avaliacao!['resposta']['imagemPerfil'].toString().isNotEmpty)
                                  ? NetworkImage('https://${ApiConfig.baseUrl}/${avaliacao!['resposta']['imagemPerfil']}')
                                  : null,
                              backgroundColor: Colors.grey[200],
                              child: (avaliacao!['resposta']['imagemPerfil'] == null ||
                                      avaliacao!['resposta']['imagemPerfil'].toString().isEmpty)
                                  ? const Icon(Icons.person, color: Colors.grey, size: 22)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      avaliacao!['resposta']['nomePrestador'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      avaliacao!['resposta']['comentario'] ?? '',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      avaliacao!['resposta']['data'] ?? '',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const Text(
                          "Responder avaliação:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _respostaController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Escreva sua resposta...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            
                            onPressed: enviandoResposta ? null : _enviarResposta,
                            icon: Icon(Icons.send),
                            label: Text("Enviar resposta", style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}