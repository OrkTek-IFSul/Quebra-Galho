import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class DetalhesSolicitacaoPage extends StatefulWidget {
  final int agendamentoId;

  const DetalhesSolicitacaoPage({super.key, required this.agendamentoId});

  @override
  State<DetalhesSolicitacaoPage> createState() => _DetalhesSolicitacaoPageState();
}

class _DetalhesSolicitacaoPageState extends State<DetalhesSolicitacaoPage> {
  int _avaliacaoEstrelas = 0;
  final TextEditingController _comentarioController = TextEditingController();

  bool _isLoading = true;
  Map<String, dynamic>? _servicoData;
  bool _servicoAvaliadoLocalmente = false;
  int? _usuarioId;

  @override
  void initState() {
    super.initState();
    _inicializarDados();
  }
  

  Future<void> _inicializarDados() async {
    final id = await obterIdUsuario();
    if (!mounted) return;
    setState(() {
      _usuarioId = id;
    });
    await _carregarDados();
  }

  String _formatarHorario(String horario) {
  try {
    final data = DateTime.parse(horario);
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes às $hora:$minuto';
  } catch (e) {
    return 'Horário inválido';
  }
}


  Future<void> _carregarDados() async {
    if (_usuarioId == null) {
      _mostrarErro('Usuário não identificado.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _servicoData = json.decode(utf8.decode(response.bodyBytes));
          _isLoading = false;
        });
      } else {
        _mostrarErro('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      _mostrarErro('Erro ao conectar ao servidor: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Color _getStatusColor(bool? statusAceito) {
    if (statusAceito == null) return Colors.orange;
    return statusAceito ? Colors.green : Colors.red;
  }

  String _getStatusText(bool? statusAceito) {
    if (statusAceito == null) return 'Pendente';
    return statusAceito ? 'Confirmado' : 'Cancelado/Negado';
  }

  String _getMessageBasedOnStatus(bool? statusAceito) {
    if (statusAceito == null) {
      return "Seu serviço está pendente de aprovação, aguarde o retorno do prestador.";
    } else if (!statusAceito) {
      return "Seu serviço foi negado ou cancelado. Você não pode avaliar este serviço.";
    }
    return "";
  }

  Future<void> _enviarAvaliacao() async {
    if (_avaliacaoEstrelas == 0 || _servicoData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma avaliação e aguarde o carregamento dos dados.')),
      );
      return;
    }

    try {
      final formattedDate = DateTime.now().toIso8601String().split('T')[0];
      final Map<String, dynamic> requestBody = {
        "nota": _avaliacaoEstrelas,
        "comentario": _comentarioController.text.trim(),
        "data": formattedDate,
        "nomeServico": _servicoData!['nome_servico'] ?? 'N/A',
        "nomeUsuario": _usuarioId.toString(),
      };

      final response = await http.post(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}/avaliacao'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação enviada com sucesso!')),
        );
        setState(() {
          _servicoAvaliadoLocalmente = true;
          _avaliacaoEstrelas = 0;
          _comentarioController.clear();
        });
      } else {
        _mostrarErro('Erro ao enviar avaliação: ${response.body}');
      }
    } catch (e) {
      _mostrarErro('Erro ao enviar avaliação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_servicoData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalhes da Solicitação")),
        body: const Center(child: Text("Não foi possível carregar os dados do serviço.")),
      );
    }

    final String nomePrestador = _servicoData!['nome_prestador'] ?? 'Prestador Indisponível';
    final String nomeServico = _servicoData!['nome_servico'] ?? 'Serviço Indisponível';
    final double precoServico = (_servicoData!['valor_servico'] as num? ?? 0.0).toDouble();
    final String imagemUrl = _servicoData!['img_prestador'] ?? '';
    final bool? statusAceito = _servicoData!['status_aceito'] as bool?;
    final bool jaAvaliado = _servicoData!['avaliado'] ?? _servicoAvaliadoLocalmente;

    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes da Solicitação")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Imagem + Dados do serviço
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: larguraTela * 0.25,
                  height: larguraTela * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: imagemUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage('https://${ApiConfig.baseUrl}/$imagemUrl'),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: imagemUrl.isEmpty ? Colors.grey[300] : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nomePrestador, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Serviço: $nomeServico"),
                      const SizedBox(height: 4),
                      Text("Horário: ${_formatarHorario(_servicoData!['horario'])}"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// 2. Valor + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Valor: R\$ ${precoServico.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusAceito),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_getStatusText(statusAceito),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// 3. Avaliação
            if (jaAvaliado)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text("Você já avaliou este serviço!",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green)),
                ),
              )
            else if (statusAceito == true) ...[
              const Text("Avalie o serviço prestado:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _avaliacaoEstrelas ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setState(() => _avaliacaoEstrelas = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _comentarioController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Escreva um comentário (opcional)...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _enviarAvaliacao,
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text("AVALIAR",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    _getMessageBasedOnStatus(statusAceito),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(statusAceito),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
