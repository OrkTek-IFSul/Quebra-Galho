import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // ou onde estiver o obterIdUsuario()

class PortfolioUploadPage extends StatefulWidget {
  const PortfolioUploadPage({super.key});

  @override
  State<PortfolioUploadPage> createState() => _PortfolioUploadPageState();
}

class _PortfolioUploadPageState extends State<PortfolioUploadPage> {
  File? _imagemSelecionada;
  final ImagePicker _picker = ImagePicker();
  bool _enviando = false;

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<void> _enviarImagem() async {
  if (_imagemSelecionada == null) return;

  final prestadorId = await obterIdPrestador();
  if (prestadorId == null) {
    _mostrarSnack("ID do prestador não encontrado.", isErro: true);
    return;
  }

  setState(() => _enviando = true);

  final url = Uri.parse('https://${ApiConfig.baseUrl}/api/portfolio/$prestadorId');

  final request = http.MultipartRequest('POST', url)
    ..files.add(await http.MultipartFile.fromPath(
      'file',
      _imagemSelecionada!.path,
      filename: p.basename(_imagemSelecionada!.path),
      contentType: MediaType('image', 'jpeg'),
    ));

  try {
    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (!mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _mostrarSnack("Imagem enviada com sucesso!");
      setState(() => _imagemSelecionada = null);

      // Aguarda o SnackBar aparecer e depois volta para tela anterior
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context, true); // <-- volta para tela de perfil
    } else {
      _mostrarSnack("Erro ao enviar imagem: $respStr", isErro: true);
    }
  } catch (e) {
    _mostrarSnack("Erro na requisição: $e", isErro: true);
  } finally {
    setState(() => _enviando = false);
  }
}


  void _mostrarSnack(String msg, {bool isErro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isErro ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar ao Portfólio"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selecionarImagem,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: _imagemSelecionada == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Clique para selecionar uma imagem"),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imagemSelecionada!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _enviando ? null : _enviarImagem,
              icon: const Icon(Icons.cloud_upload),
              label: Text(_enviando ? "Enviando..." : "Enviar para Portfólio"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
