import 'package:flutter_quebragalho/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quebragalho/services/usuario_service.dart'; 

void main() {
  
/* test('Testa atualizarUsuario altera os dados corretamente', () async {
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
}); */

/* test('Testa deletarUsuario remove o usuário com sucesso', () async {
  await UsuarioService.deletarUsuario(23);
  try {
    await UsuarioService.getUsuario(23);
    fail('Usuário ainda existe após deleção');
  } catch (e) {
    expect(e, isA<ServerException>()); // ou outra exceção esperada
  }
}); */

test('Testa obtenção da lista de usuarios', () async {
  await UsuarioService.getTodosUsuarios();
  try {
    await UsuarioService.getTodosUsuarios();
    fail('Não foi possivel obter a lista de usuários');
  } catch (e) {
    expect(e, isA<ServerException>()); // ou outra exceção esperada
  }
});


/* test('Testes do UsuarioService criarUsuario com dados válidos', () async {
final usuario = Usuario(
  nome: "Funcionario Teste Unitario",
  email: "testeunitario@email.com",
  senha: "senha122323",
  documento: "123.454.234-49",
  telefone: "(55) 23456-2555",
  isAdmin: false,
  isModerador: false,
);


    try {
      final response = await UsuarioService.criarUsuario(usuario);
      expect(response.id, isNot(0));  
      expect(response.nome, "Funcionario Teste Unitario");  
      expect(response.email, "testeunitario@email.com");  
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
  }); */
}
