import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formCliente = GlobalKey<FormState>();
  final _formPrestador = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _documentoImagem;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _documentoImagem = File(imagem.path);
      });
    }
  }

  Widget _formularioBase(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(decoration: InputDecoration(labelText: "Nome completo")),
          TextFormField(decoration: InputDecoration(labelText: "Email")),
          TextFormField(decoration: InputDecoration(labelText: "Telefone")),
          TextFormField(decoration: InputDecoration(labelText: "CPF")),
          TextFormField(
            decoration: InputDecoration(labelText: "Senha"),
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Confirmar Senha"),
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _formClienteWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _formularioBase(_formCliente),
    );
  }

  Widget _formPrestadorWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _formularioBase(_formPrestador),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Documento (CPF ou CNPJ)", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: _selecionarImagem,
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: _documentoImagem == null
                  ? Center(child: Text("Clique para selecionar imagem"))
                  : Image.file(_documentoImagem!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastro"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
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
              // Aqui pode validar os forms e processar os dados
              final abaAtual = _tabController.index;
              if (abaAtual == 0) {
                if (_formCliente.currentState!.validate()) {
                  // Processar cadastro do cliente
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cliente cadastrado!")));
                }
              } else {
                if (_formPrestador.currentState!.validate()) {
                  // Processar cadastro do prestador
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Prestador cadastrado!")));
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
