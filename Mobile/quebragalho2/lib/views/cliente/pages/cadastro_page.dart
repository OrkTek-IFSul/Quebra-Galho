import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path/path.dart' as p;

import 'login_page.dart';
import 'package:quebragalho2/api_config.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formCliente = GlobalKey<FormState>();
  final _formPrestador = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _documentoController = TextEditingController(); // Alterado
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _descricaoController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _documentoImagem;
  File? _imagemPerfil;

  // Máscaras CPF e CNPJ
  final _maskCpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  final _maskCnpj = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _maskTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Controla qual máscara e label usar (true = CPF, false = CNPJ)
  bool _isCpf = true;

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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

    final url = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/usuario/perfil/$usuarioId/imagem',
    );

    final request = http.MultipartRequest('POST', url)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          _imagemPerfil!.path,
          filename: p.basename(_imagemPerfil!.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    final response = await request.send();

    if (response.statusCode != 200 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erro ao enviar imagem de perfil: ${response.reasonPhrase}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _validarDocumento(String? value) {
    if (value == null || value.isEmpty) {
      return "Informe o CPF ou CNPJ";
    }
    final unmasked = _isCpf
        ? _maskCpf.getUnmaskedText()
        : _maskCnpj.getUnmaskedText();

    if (_isCpf && unmasked.length != 11) {
      return "CPF incompleto";
    }
    if (!_isCpf && unmasked.length != 14) {
      return "CNPJ incompleto";
    }
    return null;
  }

  Future<void> _cadastrarCliente() async {
    final url = Uri.parse('https://${ApiConfig.baseUrl}/api/cadastro/usuario');
    final telefoneLimpo = _maskTelefone.getUnmaskedText();
    final documentoLimpo =
        _isCpf ? _maskCpf.getUnmaskedText() : _maskCnpj.getUnmaskedText();

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "nome": _nomeController.text,
        "email": _emailController.text,
        "senha": _senhaController.text,
        "documento": documentoLimpo,
        "telefone": telefoneLimpo,
      }),
    );

    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final usuario = json.decode(response.body);
      final id = usuario["id"];
      await _uploadImagemPerfil(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _mostrarErro("Erro ao cadastrar: ${response.body}");
    }
  }

  Future<void> _cadastrarPrestador() async {
    if (_documentoImagem == null) {
      _mostrarErro("Por favor, selecione a imagem do seu documento.");
      return;
    }

    final url = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/cadastro/prestador',
    );
    final telefoneLimpo = _maskTelefone.getUnmaskedText();
    final documentoLimpo =
        _isCpf ? _maskCpf.getUnmaskedText() : _maskCnpj.getUnmaskedText();

    final usuario = {
      "nome": _nomeController.text,
      "email": _emailController.text,
      "senha": _senhaController.text,
      "documento": documentoLimpo,
      "telefone": telefoneLimpo,
    };

    final prestadorDTO = {
      "descricao": _descricaoController.text,
      "usuario": usuario,
    };

    final request = http.MultipartRequest('POST', url)
      ..fields['prestadorDTO'] = json.encode(prestadorDTO)
      ..files.add(
        await http.MultipartFile.fromPath(
          'imagemDocumento',
          _documentoImagem!.path,
          filename: p.basename(_documentoImagem!.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final prestador = json.decode(respStr);
      final idUsuario = prestador["usuario"]["id"];
      await _uploadImagemPerfil(idUsuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cadastro realizado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _mostrarErro("Erro ao cadastrar prestador: $respStr");
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: const Color.fromARGB(255, 235, 235, 235),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required File? imageFile,
    required VoidCallback onTap,
    required String placeholderText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey.shade300)),
              child: imageFile == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              color: Colors.grey[600], size: 40),
                          const SizedBox(height: 8),
                          Text(
                            placeholderText,
                            style: TextStyle(color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(imageFile, fit: BoxFit.cover),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formularioBase(
    GlobalKey<FormState> formKey, {
    bool prestador = false,
  }) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTextField(
            controller: _nomeController,
            label: "Nome completo",
            keyboardType: TextInputType.text, // Permite acentos
            validator: (value) =>
                value == null || value.isEmpty ? "Informe o nome" : null,
          ),
          _buildCustomTextField(
            controller: _emailController,
            label: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value == null || value.isEmpty ? "Informe o email" : null,
          ),
          _buildCustomTextField(
            controller: _telefoneController,
            label: "Telefone",
            inputFormatters: [_maskTelefone],
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value == null || value.isEmpty ? "Informe o telefone" : null,
          ),

          // Campo documento com toggle de CPF / CNPJ
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _isCpf ? "CPF" : "CNPJ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCpf = !_isCpf;
                          _documentoController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _isCpf ? "Mudar para CNPJ" : "Mudar para CPF",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _documentoController,
                  keyboardType: TextInputType.number,
                  validator: _validarDocumento,
                  inputFormatters:
                      _isCpf ? [_maskCpf] : [_maskCnpj],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 235, 235, 235),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildCustomTextField(
            controller: _senhaController,
            label: "Senha",
            obscureText: _isPasswordObscured,
            validator: (value) => value == null || value.length < 6
                ? "Senha deve ter no mínimo 6 caracteres"
                : null,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),
          _buildCustomTextField(
            controller: _confirmarSenhaController,
            label: "Confirmar Senha",
            obscureText: _isConfirmPasswordObscured,
            validator: (value) =>
                value != _senhaController.text ? "Senhas não coincidem" : null,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordObscured
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                });
              },
            ),
          ),
          if (prestador)
            _buildCustomTextField(
              controller: _descricaoController,
              label: "Descrição dos serviços",
              keyboardType: TextInputType.text, // Permite acentos
              validator: (value) =>
                  value == null || value.isEmpty ? "Informe a descrição" : null,
            ),
          _buildImagePicker(
            label: "Foto de perfil",
            imageFile: _imagemPerfil,
            onTap: _selecionarImagemPerfil,
            placeholderText: "Clique para selecionar sua foto de perfil",
          ),
        ],
      ),
    );
  }

  Widget _formClienteWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: _formularioBase(_formCliente),
    );
  }

  Widget _formPrestadorWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        children: [
          _formularioBase(_formPrestador, prestador: true),
          _buildImagePicker(
            label: "Imagem do Documento (Selfie com Doc. ou Doc. Oficial)",
            imageFile: _documentoImagem,
            onTap: _selecionarImagemDocumento,
            placeholderText: "Clique para selecionar imagem do documento",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _documentoController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.black;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Crie sua Conta", style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorWeight: 3.0,
            tabs: const [
              Tab(child: Text("Cliente", style: TextStyle(fontWeight: FontWeight.bold))),
              Tab(child: Text("Prestador", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_formClienteWidget(), _formPrestadorWidget()],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
          child: ElevatedButton(
            onPressed: () {
              final abaAtual = _tabController.index;
              if (abaAtual == 0) {
                if (_formCliente.currentState!.validate()) {
                  _cadastrarCliente();
                } else {
                  _mostrarErro("Por favor, corrija os erros no formulário.");
                }
              } else {
                if (_formPrestador.currentState!.validate()) {
                  _cadastrarPrestador();
                } else {
                  _mostrarErro("Por favor, corrija os erros no formulário.");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
            ),
            child: const Text(
              "CADASTRAR",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
