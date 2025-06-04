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
  bool _servicoAvaliado = false;


  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final response = await http.get(

        Uri.parse('http://192.168.0.155:8080/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _servicoData = json.decode(response.body);
          _isLoading = false;
        });
      } else {

        // Logar o corpo da resposta para depuração
        print('Erro ao carregar dados: ${response.statusCode} - ${response.body}');
        throw Exception('Falha ao carregar dados do serviço: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) { // Verificar se o widget ainda está montado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
      setState(() {
        _isLoading = false; // Parar o indicador de carregamento mesmo em caso de erro
      });
    }
  }
        throw Exception('Falha ao carregar dados do serviço');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Color _getStatusColor(bool? status) {
    if (status == null) return Colors.orange;
    return status ? Colors.green : Colors.red;
  }

  String _getStatusText(bool? status) {
    if (status == null) return 'Pendente';
    return status ? 'Confirmado' : 'Cancelado';
  }

  Future<void> _enviarAvaliacao() async {
    try {
      if (_avaliacaoEstrelas == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma avaliação')),
        );
        return;
      }

      final DateTime now = DateTime.now();
      // Usar a ISO 8601 string para datas é geralmente mais robusto
      final String formattedDate = now.toIso8601String().split('T')[0];

      // Verificar se _servicoData não é nulo antes de tentar acessar suas chaves
      if (_servicoData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados do serviço não carregados. Tente novamente.')),
        );
        return;
      }

      final Map<String, dynamic> requestBody = {
        "nota": _avaliacaoEstrelas,
        "comentario": _comentarioController.text.trim(),
        "data": formattedDate,
        // Garanta que estas chaves ('nome_servico', 'nome_usuario') correspondem exatamente ao que a API espera.
        // É comum que a API espere camelCase ou snake_case específico.
        "nomeServico": _servicoData?['nome_servico'] ?? '',
        "nomeUsuario": _servicoData?['nome_usuario'] ?? ''
      };

      print('Corpo da requisição de avaliação: ${json.encode(requestBody)}'); // Para depuração

      final response = await http.post(
        Uri.parse('http://192.168.0.155:8080/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}/avaliacao'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody), // Alterado para enviar um objeto, não uma lista
      );

      if (!mounted) return;

      print('Status Code da Avaliação: ${response.statusCode}'); // Para depuração
      print('Corpo da Resposta da Avaliação: ${response.body}'); // Para depuração

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação enviada com sucesso!')),
        );
        
        setState(() {
          _avaliacaoEstrelas = 0;
          _comentarioController.clear();
        });

        await _carregarDados(); // Opcional: recarregar os dados após a avaliação
      } else {
        // Se a API retornar um erro, tente extrair a mensagem de erro da resposta.
        String errorMessage = 'Falha ao enviar avaliação';
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData is String && errorData.isNotEmpty) {
            errorMessage = errorData; // API pode retornar apenas uma string de erro
          }
        } catch (e) {
          // Ignorar se a resposta não for JSON ou estiver vazia
        }
        throw Exception('$errorMessage (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar avaliação: $e')),
      );
   

  // First, add a helper method to get the message based on status
  String _getMessageBasedOnStatus(bool? status) {
    if (status == null) {
      return "Seu serviço está pendente de aprovação, aguarde o retorno do prestador.";
    } else if (!status) {
      return "Seu serviço foi negado, dessa forma você não pode avaliar esse serviço";

    }
    return "";
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

    // Adicionado um retorno caso _servicoData seja nulo após o carregamento
    if (_servicoData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalhes da Solicitação")),
        body: const Center(
          child: Text("Não foi possível carregar os dados do serviço."),
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
                        _servicoData?['nome_prestador'] ?? 'N/A',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Horário: ${_servicoData?['horario'] ?? 'N/A'}"),

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

                    color: _getStatusColor(_servicoData?['status_aceito']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(_servicoData?['status_aceito']),

                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Rating section
            if (_servicoAvaliado) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  "Você já avaliou esse serviço!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            ),

            const SizedBox(height: 32),

            /// 5. Botão de Avaliar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _enviarAvaliacao,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Avaliar"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),

            ] else if (_servicoData?['status_aceito'] == true) ...[
              // Show rating UI only for confirmed services
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
              TextField(
                controller: _comentarioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Escreva um comentário...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _enviarAvaliacao,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text("Avaliar", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Show message for pending or canceled services
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  _getMessageBasedOnStatus(_servicoData?['status_aceito']),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}