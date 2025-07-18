import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarDadosPage extends StatefulWidget {
  const EditarDadosPage({super.key});

  @override
  State<EditarDadosPage> createState() => _EditarDadosPageState();
}

class _EditarDadosPageState extends State<EditarDadosPage> {
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? _usuarioId;
  bool _isLoading = true;

  final maskCPF = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final maskCNPJ = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  late MaskTextInputFormatter currentMask;

  @override
  void initState() {
    super.initState();
    currentMask = maskCPF;
    _inicializar();
  }

  Future<void> _inicializar() async {
    final id = await obterIdUsuario();
    if (id == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: usuário não está logado')),
      );
      setState(() => _isLoading = false);
      return;
    }
    _usuarioId = id;
    await fetchUsuario();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<int?> obterIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }

  Future<void> fetchUsuario() async {
    if (_usuarioId == null) return;
    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$_usuarioId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!mounted) return;

        final documentoOriginal = data['documento'] ?? '';
        final digitsOnly = documentoOriginal.replaceAll(RegExp(r'\D'), '');

        // Detecta máscara conforme dígitos
        if (digitsOnly.length > 11) {
          currentMask = maskCNPJ;
        } else {
          currentMask = maskCPF;
        }

        setState(() {
          _nomeController.text = data['nome'] ?? '';
          _telefoneController.text = data['telefone'] ?? '';
          _emailController.text = data['email'] ?? '';
          _documentoController.text = currentMask.maskText(digitsOnly);
        });
      } else {
        throw Exception('Erro ao buscar dados do usuário');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _atualizarDados() async {
    if (_usuarioId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não identificado')),
      );
      return;
    }

    final url = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/usuario/perfil/atualizar/$_usuarioId',
    );

    final Map<String, dynamic> dados = {
      "id": _usuarioId,
      "nome": _nomeController.text,
      "email": _emailController.text,
      "telefone": _telefoneController.text,
      // Não envia documento pois não altera
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados atualizados com sucesso!")),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao atualizar: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Editar Dados",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _atualizarDados,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  const Text("Nome completo"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nomeController,
                    decoration: _customInputDecoration("Digite seu nome completo"),
                  ),
                  const SizedBox(height: 20),
                  const Text("Telefone"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '(##) #####-####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      )
                    ],
                    decoration: _customInputDecoration("(00) 00000-0000"),
                  ),
                  const SizedBox(height: 20),
                  const Text("Email"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _customInputDecoration("exemplo@email.com"),
                  ),
                  const SizedBox(height: 20),
                  const Text("CPF ou CNPJ"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _documentoController,
                    enabled: false, // Campo desabilitado para edição
                    decoration: _customInputDecoration("Documento"),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  InputDecoration _customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color.fromARGB(255, 230, 230, 230),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
