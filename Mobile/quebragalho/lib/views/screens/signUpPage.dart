import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quebragalho/models/prestador_model.dart';
import 'package:flutter_quebragalho/models/usuario_model.dart';
import 'package:flutter_quebragalho/services/prestador_service.dart';
import 'package:flutter_quebragalho/services/usuario_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

/// Página de cadastro que permite o registro de clientes e prestadores.
/// Utiliza abas para alternar entre os dois formulários.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Variável para controlar o tipo de cadastro (Cliente ou Prestador).
  bool isCliente = true;

  //Variavel para verificar se o arquivo está sendo upad
  bool _isUploading = false;

  // Variável para controlar a aceitação dos termos de compromisso e privacidade.
  bool usuarioConcordaComTermos = false;
  bool prestadorConcordaComTermos = false;

  //TextEditingController para usuario.
  final TextEditingController _nomeUsuarioController = TextEditingController();
  final TextEditingController _emailUsuarioController = TextEditingController();
  final TextEditingController _senhaUsuarioController = TextEditingController();
  final TextEditingController _senhaConfirmaUsuarioController =
      TextEditingController();
  final TextEditingController _documentoUsuarioController =
      TextEditingController();
  final TextEditingController _telefoneUsuarioController =
      TextEditingController();

  //TextEditingController para prestador.
  final TextEditingController _nomePrestadorController =
      TextEditingController();
  final TextEditingController _emailPrestadorController =
      TextEditingController();
  final TextEditingController _senhaPrestadorController =
      TextEditingController();
  final TextEditingController _senhaConfirmaPrestadorController =
      TextEditingController();
  final TextEditingController _documentoPrestadorController =
      TextEditingController();
  final TextEditingController _telefonePrestadorController =
      TextEditingController();
  // Variável para armazenar o documento selecionado para upload.
  File? file;
  // Variável para armazenar o usuario criado para o prestador.
  Usuario? usuarioPrestadorCriado;
  // Variável para armazenar o prestador criado para envio do documento.
  Prestador? prestadorCriado;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Define duas abas: uma para Cliente e outra para Prestador.
      child: Scaffold(
        // AppBar customizado para não exibir a barra superior.
        appBar: AppBar(
          backgroundColor: Colors.white, // Fundo branco.
          elevation: 0, // Remove a sombra.
          toolbarHeight: 0, // Oculta a altura da toolbar padrão.
        ),
        // Corpo da tela de cadastro com padding interno.
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Ocupa toda a largura disponível.
            children: [
              // Espaço para posicionar o título mais abaixo.
              SizedBox(height: 35),
              // Título centralizado para iniciar o cadastro.
              Text(
                'Vamos começar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              // Subtítulo explicativo sobre o cadastro.
              Text(
                'Selecione seu tipo de cadastro e adicione suas informações para começar a usufruir do app :)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 190, 190, 190),
                ),
              ),
              SizedBox(height: 16),
              // Exibição das abas para selecionar o tipo de cadastro.
              TabBar(
                indicatorColor:
                    Colors.purple, // Cor do indicador da aba selecionada.
                labelColor: Colors.purple, // Cor do texto da aba selecionada.
                unselectedLabelColor:
                    Colors.grey, // Cor do texto das abas não selecionadas.
                tabs: <Widget>[
                  Tab(text: 'Cliente'), // Aba para cadastro de clientes.
                  Tab(text: 'Prestador'), // Aba para cadastro de prestadores.
                ],
                onTap: (index) {
                  setState(() {
                    isCliente =
                        index ==
                        0; // Atualiza o estado com base na aba selecionada.
                  });
                  print('Está na aba Cliente? $isCliente');
                },
              ),
              // Conteúdo das abas (formulários).
              Expanded(
                child: TabBarView(
                  children: [
                    // Formulário de cadastro para Clientes.
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          // Aplica espaçamento horizontal relativo à largura da tela.
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo "NOME COMPLETO"
                              Text(
                                'NOME COMPLETO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 65, 1, 77),
                                ),
                              ),
                              TextField(
                                controller: _nomeUsuarioController,
                                decoration: InputDecoration(
                                  hintText: 'Digite seu nome completo',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8), // Espaçamento reduzido
                              // Linha para TELEFONE e CPF
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TELEFONE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                        TextField(
                                          controller:
                                              _telefoneUsuarioController,
                                          decoration: InputDecoration(
                                            hintText: '(99) 99999-9999',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CPF',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                        TextField(
                                          controller:
                                              _documentoUsuarioController,
                                          decoration: InputDecoration(
                                            hintText: 'XXX.XXX.XXX-XX',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Campo para EMAIL
                              Text(
                                'EMAIL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextField(
                                controller: _emailUsuarioController,
                                decoration: InputDecoration(
                                  hintText: 'Digite seu email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para NOVA SENHA
                              Text(
                                'NOVA SENHA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextField(
                                controller: _senhaUsuarioController,
                                obscureText:
                                    true, // Esconde o conteúdo digitado
                                decoration: InputDecoration(
                                  hintText: 'Digite sua nova senha',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para CONFIRMAR SENHA
                              Text(
                                'CONFIRMAR SENHA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextField(
                                controller: _senhaConfirmaUsuarioController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirme sua nova senha',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Checkbox para aceitar os termos.
                              Row(
                                children: [
                                  Checkbox(
                                    value:
                                        usuarioConcordaComTermos, // Valor inicial não selecionado.
                                    onChanged: (value) {
                                      setState(() {
                                        usuarioConcordaComTermos =
                                            value ??
                                            false; // Mantém controle se aceitou ou não os termos
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Eu aceito os termos de compromisso e privacidade',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Formulário de cadastro para Prestadores.
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo "NOME COMPLETO"
                              Text(
                                'NOME COMPLETO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 65, 1, 77),
                                ),
                              ),
                              TextField(
                                controller: _nomePrestadorController,
                                decoration: InputDecoration(
                                  hintText: 'Digite seu nome completo',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Linha para TELEFONE e CPF / CNPJ.
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'TELEFONE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                        TextField(
                                          controller:
                                              _telefonePrestadorController,
                                          decoration: InputDecoration(
                                            hintText: '(99) 99999-9999',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CPF / CNPJ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                        TextField(
                                          controller:
                                              _documentoPrestadorController,
                                          decoration: InputDecoration(
                                            hintText: 'XXX.XXX.XXX-XX',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Campo para EMAIL
                              Text(
                                'EMAIL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextField(
                                controller: _emailPrestadorController,
                                decoration: InputDecoration(
                                  hintText: 'Digite seu email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Seção para UPLOAD DE DOCUMENTO
                              Text(
                                'UPLOAD DE DOCUMENTO',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Container que simula a área de upload para documentos
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    // Abre o seletor de arquivos
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                          ], // Tipos de arquivos permitidos
                                        );

                                    if (result != null &&
                                        result.files.single.path != null) {
                                      setState(() {
                                        _isUploading = true;
                                      });

                                      // Obtém o arquivo selecionado
                                      file = File(result.files.single.name);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Erro no upload da imagem',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 243, 173, 255),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color.fromARGB(50, 230, 200, 250),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload,
                                          size: 40,
                                          color: Colors.purple,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Upload de documento',
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '(RG, CPF ou Comprovante de CNPJ)',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para NOVA SENHA
                              Text(
                                'NOVA SENHA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextField(
                                controller: _senhaPrestadorController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Digite sua nova senha',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Campo para CONFIRMAR SENHA
                              Text(
                                'CONFIRMAR SENHA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextField(
                                controller: _senhaConfirmaPrestadorController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Confirme sua nova senha',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              // Checkbox para aceitar os termos.
                              Row(
                                children: [
                                  Checkbox(
                                    value: prestadorConcordaComTermos,
                                    onChanged: (value) {
                                      setState(() {
                                        prestadorConcordaComTermos =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Eu aceito os termos de compromisso e privacidade',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Botão "Cadastrar" fixado no rodapé da tela.
        bottomNavigationBar: SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              //Se for Cliente
              if (isCliente) {
                // Validações dos campos
                if (_nomeUsuarioController.text.isEmpty ||
                    _telefoneUsuarioController.text.isEmpty ||
                    _documentoUsuarioController.text.isEmpty ||
                    _emailUsuarioController.text.isEmpty ||
                    _senhaUsuarioController.text.isEmpty ||
                    _senhaConfirmaUsuarioController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos'),
                    ),
                  );
                  return;
                }
                //Valida se as senhas são iguais
                if (_senhaUsuarioController.text !=
                    _senhaConfirmaUsuarioController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('As senhas não coincidem')),
                  );
                  return;
                }
                //Verifica se o usuário concorda com os termos
                if (!usuarioConcordaComTermos) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Você precisa aceitar os termos para prosseguir',
                      ),
                    ),
                  );
                  return;
                }
                //Cria um novo Usuário com as informações
                final novoUsuario = Usuario(
                  nome: _nomeUsuarioController.text,
                  email: _emailUsuarioController.text,
                  senha: _senhaUsuarioController.text,
                  documento: _documentoUsuarioController.text,
                  telefone: _telefoneUsuarioController.text,
                );
                //Abre o envio para a API
                try {
                  //Tenta enviar
                  await UsuarioService.criarUsuario(novoUsuario);
                  //Sucesso
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Usuário cadastrado com sucesso!')),
                  );
                } catch (e) {
                  //Caso aconteça algum erro na hora do envio
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erro ao cadastrar Usuário: ${e.toString()}',
                      ),
                    ),
                  );
                }
                //TODO Redirect para a tela de login ou outra ação desejada
              } else {
                // Lógica para cadastrar prestador.
                // Validações para o Prestador
                if (_nomePrestadorController.text.isEmpty ||
                    _telefonePrestadorController.text.isEmpty ||
                    _documentoPrestadorController.text.isEmpty ||
                    _emailPrestadorController.text.isEmpty ||
                    _senhaPrestadorController.text.isEmpty ||
                    _senhaConfirmaPrestadorController.text.isEmpty ||
                    file == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos'),
                    ),
                  );
                  return;
                }

                if (_senhaPrestadorController.text !=
                    _senhaConfirmaPrestadorController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('As senhas não coincidem')),
                  );
                  return;
                }

                if (!prestadorConcordaComTermos) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Você precisa aceitar os termos para prosseguir',
                      ),
                    ),
                  );
                  return;
                }

                // Criar instância de usuário do Prestador
                final novoPrestador = Usuario(
                  nome: _nomePrestadorController.text,
                  telefone: _telefonePrestadorController.text,
                  documento: _documentoPrestadorController.text,
                  email: _emailPrestadorController.text,
                  senha: _senhaPrestadorController.text,
                );

                // Aqui você pode salvar o prestador
                try {
                  //Request para criar o usuário do prestador
                  usuarioPrestadorCriado = await UsuarioService.criarUsuario(
                    novoPrestador,
                  );
                  //Cria o prestador 
                  final prestador = Prestador(
                    descricao: 'Prestador recém criado',
                  );
                  //Request para criar o prestador
                  final prestadorCriado = await PrestadorService.criarPrestador(
                    prestador.toJson(),
                    'http://localhost:8080/api/prestadores/${usuarioPrestadorCriado!.id}',
                  );
                  //Upload do documento do prestador
                  await PrestadorService.uploadImagemDocumento(
                    prestadorCriado.id!,
                    file!,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Prestador cadastrado com sucesso!'),
                    ),
                  );
                  //TODO Redirect para a tela de login ou outra ação desejada
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erro ao cadastrar prestador: ${e.toString()}',
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // Cor de fundo do botão.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Remove cantos arredondados.
              ),
            ),
            child: Text(
              'Cadastrar',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
