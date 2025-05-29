import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetalhesSolicitacaoPage extends StatefulWidget {
  final int agendamentoId;

  const DetalhesSolicitacaoPage({
    super.key,
    required this.agendamentoId,
  });

  @override
  State<DetalhesSolicitacaoPage> createState() => _DetalhesSolicitacaoPageState();
}

class _DetalhesSolicitacaoPageState extends State<DetalhesSolicitacaoPage> {
  int _avaliacaoEstrelas = 0;
  final TextEditingController _comentarioController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _servicoData;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      // Substitua pela sua URL real
      final response = await http.get(
        
        Uri.parse('http://192.168.0.155:8080/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _servicoData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar dados do serviço');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Color _getStatusColor(bool status) {
    return status ? Colors.green : Colors.red;
  }

  String _getStatusText(bool status) {
    return status ? 'Confirmado' : 'Cancelado';
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Solicitação"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: larguraTela * 0.3,
                  height: larguraTela * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300], // Placeholder para imagem
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _servicoData?['nome_prestador'] ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Horário: ${_servicoData?['horario'] ?? ''}"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status do Serviço:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_servicoData?['status_servico'] ?? false),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(_servicoData?['status_servico'] ?? false),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 3. Rating com estrelas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _avaliacaoEstrelas ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _avaliacaoEstrelas = index + 1;
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 16),

            /// 4. Campo de comentário
            TextField(
              controller: _comentarioController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Escreva um comentário...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 32),

            /// 5. Botão de Avaliar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Aqui você pode enviar a avaliação e comentário
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Avaliação enviada com sucesso!')),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Avaliar"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
