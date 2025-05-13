import 'dart:convert';
import 'package:http/http.dart' as http;

class EditarServicoService {
  static final EditarServicoService _instance = EditarServicoService._internal();
  factory EditarServicoService() => _instance;
  EditarServicoService._internal();

  static const String _baseUrl = 'http://10.0.0.167:8080';
  Future<bool> atualizarServico({
    required int idPrestador,
    required int idServico,
    required String nome,
    required String descricao,
    required int valor,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/api/prestador/servico/$idPrestador/$idServico'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'descricao': descricao,
          'preco': valor.toDouble(),
          'tags': [],
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
    
  }
}