import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'login_page.dart'; // substitua pelo caminho real do LoginPage

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formCliente = GlobalKey<FormState>();
  final _formPrestador = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _descricaoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _documentoImagem;
  File? _imagemPerfil;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _selecionarImagemDocumento() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _documentoImagem = File(imagem.path);
      });
    }
  }

  Future<void> _selecionarImagemPerfil() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemPerfil = File(imagem.path);
      });
    }
  }

  Future<void> _uploadImagemPerfil(int usuarioId) async {
    if (_imagemPerfil == null) return;

    final url = Uri.parse('http://192.168.1.24:8080/api/usuario/perfil/$usuarioId/imagem');

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', _imagemPerfil!.path));

    final response = await request.send();

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erro ao enviar imagem de perfil"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _cadastrarCliente() async {
    final url = Uri.parse('http://192.168.1.24:8080/api/cadastro/usuario');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "nome": _nomeController.text,
        "email": _emailController.text,
        "senha": _senhaController.text,
        "documento": _cpfController.text,
        "telefone": _telefoneController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final usuario = json.decode(response.body);
      final id = usuario["id"];
      await _uploadImagemPerfil(id);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Cadastro realizado com sucesso!"),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erro ao cadastrar: ${response.body}"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _cadastrarPrestador() async {
    if (_documentoImagem == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Selecione uma imagem do documento"),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    final url = Uri.parse('http://192.168.1.24:8080/api/cadastro/prestador');

    final usuario = {
      "nome": _nomeController.text,
      "email": _emailController.text,
      "senha": _senhaController.text,
      "documento": _cpfController.text,
      "telefone": _telefoneController.text,
    };

    final prestadorDTO = {
      "descricao": _descricaoController.text,
      "usuario": usuario,
    };

    final request = http.MultipartRequest('POST', url)
      ..fields['prestadorDTO'] = json.encode(prestadorDTO)
      ..files.add(await http.MultipartFile.fromPath('imagemDocumento', _documentoImagem!.path));

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      final prestador = json.decode(respStr);
      final idUsuario = prestador["usuario"]["id"];
      await _uploadImagemPerfil(idUsuario);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Cadastro realizado com sucesso!"),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erro ao cadastrar prestador"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Widget _formularioBase(GlobalKey<FormState> formKey, {bool prestador = false}) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: "Nome completo"),
            validator: (value) => value == null || value.isEmpty ? "Informe o nome" : null,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email"),
            validator: (value) => value == null || value.isEmpty ? "Informe o email" : null,
          ),
          TextFormField(
            controller: _telefoneController,
            decoration: InputDecoration(labelText: "Telefone"),
            validator: (value) => value == null || value.isEmpty ? "Informe o telefone" : null,
          ),
          TextFormField(
            controller: _cpfController,
            decoration: InputDecoration(labelText: "CPF/CNPJ"),
            validator: (value) => value == null || value.isEmpty ? "Informe o CPF/CNPJ" : null,
          ),
          TextFormField(
            controller: _senhaController,
            decoration: InputDecoration(labelText: "Senha"),
            obscureText: true,
            validator: (value) => value == null || value.length < 6 ? "Senha muito curta" : null,
          ),
          TextFormField(
            controller: _confirmarSenhaController,
            decoration: InputDecoration(labelText: "Confirmar Senha"),
            obscureText: true,
            validator: (value) =>
                value != _senhaController.text ? "Senhas não coincidem" : null,
          ),
          if (prestador)
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: "Descrição dos serviços"),
              validator: (value) =>
                  value == null || value.isEmpty ? "Informe a descrição" : null,
            ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Foto de perfil", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selecionarImagemPerfil,
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: _imagemPerfil == null
                  ? Center(child: Text("Clique para selecionar imagem de perfil"))
                  : Image.file(_imagemPerfil!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formClienteWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _formularioBase(_formCliente),
    );
  }

  Widget _formPrestadorWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _formularioBase(_formPrestador, prestador: true),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Documento (CPF ou CNPJ)", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selecionarImagemDocumento,
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: _documentoImagem == null
                  ? Center(child: Text("Clique para selecionar imagem do documento"))
                  : Image.file(_documentoImagem!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Cadastro"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Cliente"),
              Tab(text: "Prestador"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _formClienteWidget(),
            _formPrestadorWidget(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              final abaAtual = _tabController.index;
              if (abaAtual == 0) {
                if (_formCliente.currentState!.validate()) {
                  _cadastrarCliente();
                }
              } else {
                if (_formPrestador.currentState!.validate()) {
                  _cadastrarPrestador();
                }
              }
            },
            child: Text("Cadastrar"),
          ),
        ),
      ),
    );
  }
}
