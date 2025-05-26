import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetalhesSolicitacaoPage extends StatefulWidget {
  final String nome;
  final String fotoUrl;
  final String servico;
  final String dataHora;
  final double valorTotal;
  final int idAgendamento;

  const DetalhesSolicitacaoPage({
    super.key,
    required this.nome,
    required this.fotoUrl,
    required this.servico,
    required this.dataHora,
    required this.valorTotal,
    required this.idAgendamento,
  });

  @override
  State<DetalhesSolicitacaoPage> createState() =>
      _DetalhesSolicitacaoPageState();
}

class _DetalhesSolicitacaoPageState extends State<DetalhesSolicitacaoPage> {
  bool isLoading = false;

  Future<void> _confirmarSolicitacao() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse(
          'http://192.168.0.155:8080/api/prestador/pedidoservico/${widget.idAgendamento}/aceitar',
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Solicitação de ${widget.nome} confirmada com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Return true to indicate success and trigger UI update
        Navigator.pop(context, true);
      } else {
        throw Exception('Falha ao confirmar solicitação');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao confirmar solicitação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Solicitação')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome do cliente: ${widget.nome}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Serviço: ${widget.servico}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Data e hora: ${widget.dataHora}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Valor total: R\$ ${widget.valorTotal}',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //BOTÃO DE CONFIRMAR
                ElevatedButton.icon(
                  onPressed: isLoading ? null : _confirmarSolicitacao,
                  icon:
                      isLoading
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(Icons.check),
                  label: Text(isLoading ? 'Confirmando...' : 'Confirmar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                //BOTÃO DE CANCELAR
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Solicitação recusada')),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Recusar'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
