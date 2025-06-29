import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:path/path.dart' as p;

// import '../../pages/login_page.dart';
// TODO: Update the import below to the correct path if 'login_page.dart' exists elsewhere.
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class ModalFormularioPrestador extends StatefulWidget {
  const ModalFormularioPrestador({super.key});

  @override
  State<ModalFormularioPrestador> createState() => _ModalFormularioPrestadorState();
}

class _ModalFormularioPrestadorState extends State<ModalFormularioPrestador> {
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

  final _maskTelefone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _maskCpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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

  Future<void> _cadastrarPrestador() async {
    if (_documentoImagem == null) {
      _mostrarErro("Por favor, selecione a imagem do seu documento.");
      return;
    }

    final url = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/cadastro/prestador',
    );
    final telefoneLimpo = _maskTelefone.getUnmaskedText();
    final cpfLimpo = _maskCpf.getUnmaskedText();

    final usuario = {
      "nome": _nomeController.text,
      "email": _emailController.text,
      "senha": _senhaController.text,
      "documento": cpfLimpo,
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
        MaterialPageRoute(builder: (_) => LoginPage()),
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
    List? inputFormatters,
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
            inputFormatters: inputFormatters?.cast<TextInputFormatter>(),
            obscureText: obscureText,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: const Color.fromARGB(255, 235, 235, 235),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
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
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
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
                          Icon(Icons.camera_alt_outlined, color: Colors.grey[600], size: 40),
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

  Widget _formularioPrestador() {
    return Form(
      key: _formPrestador,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomTextField(
            controller: _nomeController,
            label: "Nome completo",
            validator: (value) => value == null || value.isEmpty ? "Informe o nome" : null,
          ),
          _buildCustomTextField(
            controller: _emailController,
            label: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value == null || value.isEmpty ? "Informe o email" : null,
          ),
          _buildCustomTextField(
            controller: _telefoneController,
            label: "Telefone",
            inputFormatters: [_maskTelefone],
            keyboardType: TextInputType.phone,
            validator: (value) => value == null || value.isEmpty ? "Informe o telefone" : null,
          ),
          _buildCustomTextField(
            controller: _cpfController,
            label: "CPF",
            inputFormatters: [_maskCpf],
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? "Informe o CPF" : null,
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
            validator: (value) => value != _senhaController.text ? "Senhas não coincidem" : null,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                });
              },
            ),
          ),
          _buildCustomTextField(
            controller: _descricaoController,
            label: "Descrição dos serviços",
            validator: (value) => value == null || value.isEmpty ? "Informe a descrição" : null,
          ),
          _buildImagePicker(
            label: "Foto de perfil",
            imageFile: _imagemPerfil,
            onTap: _selecionarImagemPerfil,
            placeholderText: "Clique para selecionar sua foto de perfil",
          ),
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

  @override
  void dispose() {
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
    final primaryColor = Colors.black;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Cadastro Prestador"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: _formularioPrestador(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formPrestador.currentState!.validate()) {
              _cadastrarPrestador();
            } else {
              _mostrarErro("Por favor, corrija os erros no formulário.");
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
    );
  }
}