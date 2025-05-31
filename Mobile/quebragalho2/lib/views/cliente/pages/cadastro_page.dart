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

  // Controladores para los campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfCnpjController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _documentoImagem = File(imagem.path);
      });
    }
  }

  String? _validarCampoObrigatorio(String? value, String campo) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha $campo';
    }
    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha o email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }

  String? _validarNumeros(String? value, String campo) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha $campo';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '$campo deve conter apenas números';
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha a senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? _validarConfirmarSenha(String? value) {
    if (value != _senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? campoObrigatorio,
    bool soloNumeros = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorStyle: TextStyle(color: Colors.red),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType ?? (soloNumeros ? TextInputType.number : TextInputType.text),
        style: TextStyle(fontSize: 16),
        validator: validator ?? (value) => soloNumeros 
            ? _validarNumeros(value, campoObrigatorio ?? label)
            : _validarCampoObrigatorio(value, campoObrigatorio ?? label),
      ),
    );
  }

  Widget _formularioBase(GlobalKey<FormState> formKey) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(
            label: "Nome completo",
            controller: _nomeController,
            campoObrigatorio: "o nome completo",
          ),
          SizedBox(height: 8),
          _buildTextField(
            label: "Email",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
          ),
          SizedBox(height: 8),
          _buildTextField(
            label: "Telefone",
            controller: _telefoneController,
            keyboardType: TextInputType.phone,
            campoObrigatorio: "o telefone",
            soloNumeros: true,
          ),
          SizedBox(height: 8),
          _buildTextField(
            label: "CPF/CNPJ",
            controller: _cpfCnpjController,
            keyboardType: TextInputType.number,
            campoObrigatorio: "o CPF/CNPJ",
            soloNumeros: true,
          ),
          SizedBox(height: 8),
          _buildTextField(
            label: "Senha",
            controller: _senhaController,
            obscureText: true,
            validator: _validarSenha,
          ),
          SizedBox(height: 8),
          _buildTextField(
            label: "Confirmar Senha",
            controller: _confirmarSenhaController,
            obscureText: true,
            validator: _validarConfirmarSenha,
          ),
        ],
      ),
    );
  }

  Widget _formClienteWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.person_add_alt_1, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Cadastro de Cliente",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _formularioBase(_formCliente),
          ],
        ),
      ),
    );
  }

  Widget _formPrestadorWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.business_center, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Cadastro de Prestador",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _formularioBase(_formPrestador),
            SizedBox(height: 20),
            Text(
              "Documento (CPF ou CNPJ)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: _selecionarImagem,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _documentoImagem == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "Toque para selecionar o documento",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_documentoImagem!, fit: BoxFit.cover),
                      ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Crie sua conta",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.white,
                      indicatorWeight: 4,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.person_outline),
                          text: "Cliente",
                        ),
                        Tab(
                          icon: Icon(Icons.business_outlined),
                          text: "Prestador",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _formClienteWidget(),
                  _formPrestadorWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Theme.of(context).primaryColor,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 60), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white, width: 2),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            elevation: 5, 
          ),
          onPressed: () {
            final abaAtual = _tabController.index;
            if (abaAtual == 0) {
              if (_formCliente.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Cliente cadastrado com sucesso!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                _mostrarErro("Por favor, preencha todos os campos corretamente");
              }
            } else {
              if (_documentoImagem == null) {
                _mostrarErro("Por favor, selecione a imagem do documento");
                return;
              }
              if (_formPrestador.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Prestador cadastrado com sucesso!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                _mostrarErro("Por favor, preencha todos os campos corretamente");
              }
            }
          },
          child: Text(
            "CADASTRAR",
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2, 
            ),
          ),
        ),
      ),
    );
  }
}