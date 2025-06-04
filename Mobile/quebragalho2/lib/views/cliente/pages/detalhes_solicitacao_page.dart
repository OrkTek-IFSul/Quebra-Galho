import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetalhesSolicitacaoPage extends StatefulWidget {
  final int agendamentoId;
  // Removidas propriedades que não existiam e não eram usadas ou foram substituídas por _servicoData
  // final String nome;
  // final String horario;
  // final String valor;
  // final String imagemUrl;
  // final bool status;

  const DetalhesSolicitacaoPage({
    super.key,
    required this.agendamentoId,
    // required this.nome,
    // required this.horario,
    // required this.valor,
    // required this.imagemUrl,
    // required this.status,
  });

  @override
  State<DetalhesSolicitacaoPage> createState() => _DetalhesSolicitacaoPageState();
}

class _DetalhesSolicitacaoPageState extends State<DetalhesSolicitacaoPage> {
  int _avaliacaoEstrelas = 0;
  final TextEditingController _comentarioController = TextEditingController();

  bool _isLoading = true;
  Map<String, dynamic>? _servicoData;
  bool _servicoAvaliadoLocalmente = false; // Para controlar se o usuário já tentou avaliar nesta sessão

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.155:8080/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _servicoData = json.decode(response.body);
          // Exemplo: Verificar se a API informa que já foi avaliado
          // _servicoAvaliadoLocalmente = _servicoData?['avaliado'] ?? false;
          _isLoading = false;
        });
      } else {
        print('Erro ao carregar dados: ${response.statusCode} - ${response.body}');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao carregar dados do serviço: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exceção ao carregar dados: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor: $e')),
      );
    }
  }

  // Métodos Helper para Status e Mensagens
  Color _getStatusColor(bool? statusAceito) {
    if (statusAceito == null) return Colors.orange; // Pendente
    return statusAceito ? Colors.green : Colors.red; // Confirmado : Cancelado/Negado
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
    // Se confirmado e não avaliado, a UI de avaliação será mostrada.
    // Se confirmado e já avaliado, outra mensagem será mostrada.
    return ""; // String vazia para casos onde a UI de avaliação é mostrada
  }


  Future<void> _enviarAvaliacao() async {
    if (_avaliacaoEstrelas == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma avaliação de estrelas')),
      );
      return;
    }

    if (_servicoData == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados do serviço não carregados. Tente novamente.')),
      );
      return;
    }

    try {
      final DateTime now = DateTime.now();
      final String formattedDate = now.toIso8601String().split('T')[0];

      final Map<String, dynamic> requestBody = {
        "nota": _avaliacaoEstrelas,
        "comentario": _comentarioController.text.trim(),
        "data": formattedDate,
        "nomeServico": _servicoData!['nome_servico'] ?? 'N/A',
        "nomeUsuario": _servicoData!['nome_usuario'] ?? 'N/A', // Supondo que esta chave exista
      };

      print('Corpo da requisição de avaliação: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('http://192.168.0.155:8080/api/usuario/solicitacoes/agendamento/${widget.agendamentoId}/avaliacao'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (!mounted) return;

      print('Status Code da Avaliação: ${response.statusCode}');
      print('Corpo da Resposta da Avaliação: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avaliação enviada com sucesso!')),
        );
        setState(() {
          _servicoAvaliadoLocalmente = true; // Marcar como avaliado localmente
          // Limpar campos se desejar, ou pode recarregar os dados para refletir estado da API
          _avaliacaoEstrelas = 0;
          _comentarioController.clear();
        });
        // Opcional: await _carregarDados(); // Para atualizar o estado com base na resposta da API, se necessário
      } else {
        String errorMessage = 'Falha ao enviar avaliação';
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData is String && errorData.isNotEmpty) {
            errorMessage = errorData;
          }
        } catch (_) { /* Ignorar erro de parsing do corpo do erro */ }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage (Status: ${response.statusCode})')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar avaliação: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_servicoData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalhes da Solicitação")),
        body: const Center(
          child: Text("Não foi possível carregar os dados do serviço."),
        ),
      );
    }

    // Extraindo dados do _servicoData para facilitar o uso no build
    final String nomePrestador = _servicoData!['nome_prestador'] ?? 'Prestador Indisponível';
    final String nomeServico = _servicoData!['nome_servico'] ?? 'Serviço Indisponível';
    final String horarioFormatado = _servicoData!['horario'] ?? 'N/A'; // Idealmente formatar DateTime
    final double precoServico = (_servicoData!['preco_servico'] as num? ?? 0.0).toDouble();
    final String imagemUrl = _servicoData!['imagem_url_prestador'] ?? ''; // Use uma URL de imagem válida
    final bool? statusAceito = _servicoData!['status_aceito'] as bool?;
    
    // Determina se o serviço já foi avaliado (pode vir da API ou ser o estado local)
    // Se a API retornar um campo 'avaliado', use-o. Caso contrário, use o estado local.
    final bool jaAvaliado = _servicoData!['avaliado'] ?? _servicoAvaliadoLocalmente;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Solicitação"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinhar filhos à esquerda
          children: [
            /// 1. Linha com imagem + nome + horário
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: larguraTela * 0.25, // Ajuste de tamanho
                  height: larguraTela * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: imagemUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imagemUrl),
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
                      Text(
                        nomePrestador,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Serviço: $nomeServico"),
                      const SizedBox(height: 4),
                      Text("Horário: $horarioFormatado"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// 2. Linha com valor + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Valor: R\$ ${precoServico.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusAceito),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(statusAceito),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// 3. Seção de Avaliação Condicional
            if (jaAvaliado) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center( // Centralizar texto
                  child: Text(
                    "Você já avaliou este serviço!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ] else if (statusAceito == true) ...[ // Permitir avaliação apenas se confirmado e não avaliado
              const Text(
                "Avalie o serviço prestado:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                  label: const Text("AVALIAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Theme.of(context).primaryColor, // Usar cor primária do tema
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ] else ...[ // Se pendente ou negado/cancelado
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center( // Centralizar texto
                  child: Text(
                    _getMessageBasedOnStatus(statusAceito),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(statusAceito), // Cor de acordo com o status
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20), // Espaço no final
          ],
        ),
      ),
    );
  }
}