import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class DetalhesApeloPage extends StatelessWidget {
  final Map<String, dynamic> apelo;

  const DetalhesApeloPage({super.key, required this.apelo});

  Future<void> _atualizarStatus(BuildContext context, bool aceitar) async {
    final id = apelo['apeloId'];
    final rota = aceitar ? 'aceitarApelo' : 'recusarApelo';
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/$rota/$id',
    );
    try {
      final resp = await http.put(uri);
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Apelo ${aceitar ? "aceito" : "recusado"} com sucesso.',
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Status ${resp.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
    }
  }

  Widget _campo(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final denuncia = apelo['denuncia'] as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Apelo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📝 Dados do Apelo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _campo('ID do Apelo', '${apelo['apeloId']}'),
            _campo('Justificativa', apelo['justificativa'] ?? ''),
            _campo(
              'Status do Apelo',
              apelo['status'] == null
                  ? 'Pendente'
                  : (apelo['status'] == true ? 'Aceito' : 'Recusado'),
            ),
            const Divider(height: 32),

            const Text(
              '📄 Dados da Denúncia Associada',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _campo('ID da Denúncia', '${denuncia['denunciaId']}'),
            _campo('Tipo', denuncia['tipo'] ?? ''),
            _campo('Motivo', denuncia['motivo'] ?? ''),
            _campo('Denunciante', denuncia['nomeDenunciante'] ?? ''),
            _campo('Denunciado', denuncia['nomeDenunciado'] ?? ''),
            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Aceitar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => _atualizarStatus(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Recusar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => _atualizarStatus(context, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
