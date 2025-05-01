import 'dart:io';
import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_quebragalho/utils/api_endpoints.dart';
import '../models/usuario_model.dart';

// Classe UsuarioService fornece métodos para gerenciar usuários, como criar, atualizar, deletar e gerenciar imagens de perfil.
class UsuarioService {
  // Obtém os dados de um usuário específico pelo ID.
  static Future<Usuario> getUsuario(int id) async {
    final response = await ApiService.get(ApiEndpoints.getUsuario(id));
    return Usuario.fromJson(response);
  }

  // Obtém a lista de todos os usuários.
  static Future<List<Usuario>> getTodosUsuarios() async {
    final response = await ApiService.get(ApiEndpoints.getUsuarios);
    return (response as List).map((json) => Usuario.fromJson(json)).toList();
  }

  // Cria um novo usuário, enviando os dados via API.
  static Future<Usuario> criarUsuario(Usuario usuario) async {
    final response = await ApiService.post(
      ApiEndpoints.criarUsuario,
      body: usuario.toJson(includeSensitive: true),
    );
    return Usuario.fromJson(response);
  }

  // Atualiza os dados de um usuário existente pelo ID.
  static Future<Usuario> atualizarUsuario(int id, Usuario usuario) async {
    final response = await ApiService.put(
      ApiEndpoints.atualizarUsuario(id),
      body: usuario.toJson(),
    );
    return Usuario.fromJson(response);
  }

  // Deleta um usuário específico pelo ID.
  static Future<void> deletarUsuario(int id) async {
    await ApiService.delete(ApiEndpoints.deletarUsuario(id));
  }

  // Faz o upload de uma imagem de perfil para um usuário específico.
  static Future<String> uploadImagemPerfil(int usuarioId, File imagem) async {
    final response = await ApiService.uploadFile(
      ApiEndpoints.uploadImagemUsuario(usuarioId),
      imagem,
      fieldName: 'imagem',
    );
    return response['url'] as String;
  }

  // Remove a imagem de perfil de um usuário específico.
  static Future<void> removerImagemPerfil(int usuarioId) async {
    await ApiService.delete(ApiEndpoints.removerImagemUsuario(usuarioId));
  }
}