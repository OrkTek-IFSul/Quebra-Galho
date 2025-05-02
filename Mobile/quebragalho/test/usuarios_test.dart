import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/services/usuario_service.dart'; 
import 'package:flutter_quebragalho/models/usuario_model.dart'; 

void main() {
  
test('Testa atualizarUsuario altera os dados corretamente', () async {
  final usuarioCriado = await UsuarioService.criarUsuario(Usuario(
  nome: "Nome original",
  email: "update@email.com",
  senha: "senha123",
  documento: "000.000.000-00",
  telefone: "(00) 00000-0000",
  isAdmin: false,
  isModerador: false,
));


  final atualizado = usuarioCriado.copyWith(nome: "Nome atualizado");
  final usuarioAtualizado = await UsuarioService.atualizarUsuario(usuarioCriado.id!, atualizado);

  expect(usuarioAtualizado.nome, "Nome atualizado");
});

test('Testa deletarUsuario remove o usuário com sucesso', () async {
  final usuario = await UsuarioService.criarUsuario(Usuario(
  nome: "Nome original",
  email: "update@email.com",
  senha: "senha123",
  documento: "000.000.000-00",
  telefone: "(00) 00000-0000",
  isAdmin: false,
  isModerador: false,
  ));

  await UsuarioService.deletarUsuario(usuario.id!);

  try {
    await UsuarioService.getUsuario(usuario.id!);
    fail('Usuário ainda existe após deleção');
  } catch (e) {
    expect(e, isA<ServerException>()); // ou outra exceção esperada
  }
});


  test('Testes do UsuarioService criarUsuario com dados válidos', () async {
final usuario = Usuario(
  nome: "Funcionarioooos",
  email: "testeteste@email.com",
  senha: "senha122323",
  documento: "123.123.456-49",
  telefone: "(55) 23456-2555",
  isAdmin: false,
  isModerador: false,
);


    try {
      final response = await UsuarioService.criarUsuario(usuario);
      expect(response.id, isNot(0));  
      expect(response.nome, "Funcionarioooos");  
      expect(response.email, "testeteste@email.com");  
      expect(response.isAdmin, false);  
      expect(response.isModerador, false);  
    } catch (e) {
      print('Erro ao criar usuário: $e');
      if (e is ServerException) {
        print('Erro específico do servidor: ${e.message}');
      } else if (e is UnknownException) {
        print('Erro desconhecido: ${e.message}');
      }
    }
  });
}
