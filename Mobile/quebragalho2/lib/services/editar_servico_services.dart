///
/// Perfil Service - Quebra Galho App
/// By Jean Carlo | Orktek
/// github.com/jeankeitwo16
/// Descrição: Serviço de edição de serviços, onde o prestador pode atualizar os detalhes de um serviço específico, como nome, descrição e valor.
/// Versão: 1.0.0
///
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class EditarServicoService {
  static final EditarServicoService _instance = EditarServicoService._internal();
  factory EditarServicoService() => _instance;
  EditarServicoService._internal();

  static const String _baseUrl = 'https://${ApiConfig.baseUrl}';

  Future<bool> atualizarServico({
    required int idPrestador,
    required int idServico,
    required String nome,
    required String descricao,
    required double valor,  // mudou para double
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/api/prestador/servico/$idPrestador/$idServico'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'descricao': descricao,
          'preco': valor,  // já é double, envia direto
          'tags': [],
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}