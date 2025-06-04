///
/// Perfil Service - Quebra Galho App
/// By Jean Carlo | Orktek
/// github.com/jeankeitwo16
/// Descrição: Serviço de perfil do usuário, onde é possível buscar, atualizar e gerenciar a imagem de perfil do usuário.
/// Versão: 1.0.0
///
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:quebragalho2/api_config.dart';

class PerfilPageService {
  final String baseUrl = 'http://${ApiConfig.baseUrl}/api/usuario/perfil'; // ajuste conforme necessário

  Future<Map<String, dynamic>> buscarPerfilUsuario(int usuarioId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/$usuarioId'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Falha ao carregar perfil do usuário');
  }
}


  Future<String?> uploadImagemPerfil(int usuarioId, File imagem) async {
    final uri = Uri.parse('$baseUrl/$usuarioId/imagem');
    final request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(imagem.path) ?? 'image/jpeg';
    final fileStream = await http.MultipartFile.fromPath(
      'file',
      imagem.path,
      contentType: MediaType.parse(mimeType),
    );

    request.files.add(fileStream);

    final response = await request.send();

    if (response.statusCode == 200) {
      final resposta = await response.stream.bytesToString();
      return resposta;
    } else {
      print('Erro ao fazer upload: ${response.statusCode}');
      return null;
    }
  }

  Future<bool> removerImagemPerfil(int usuarioId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$usuarioId/removerimagem'));

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Erro ao remover imagem: ${response.statusCode}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> atualizarPerfilUsuario(
      int usuarioId, Map<String, dynamic> dadosAtualizados) async {
    final response = await http.put(
      Uri.parse('$baseUrl/atualizar/$usuarioId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dadosAtualizados),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Erro ao atualizar perfil: ${response.statusCode}');
      return null;
    }
  }
}
