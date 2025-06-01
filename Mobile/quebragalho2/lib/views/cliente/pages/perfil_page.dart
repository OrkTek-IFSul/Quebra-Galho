///
/// Perfil View - Quebra Galho App
/// By Jean Carlo | Orktek
/// github.com/jeankeitwo16
/// Descrição: Página de perfil do usuário, onde é possível visualizar e editar os dados do usuário, como nome, telefone, email e CPF. Também permite o upload de uma imagem de perfil e visualização das solicitações feitas pelo usuário. 
/// Versão: 1.0.0
///
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quebragalho2/services/perfil_page_services.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';
import 'package:quebragalho2/views/cliente/pages/minhas_solicitacoes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/info_campos_perfil.dart';

class PerfilPage extends StatefulWidget {
  final int usuarioId;
  const PerfilPage({super.key, required this.usuarioId});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late Future<Map<String, dynamic>> _dadosUsuario;
  XFile? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _dadosUsuario = PerfilPageService().buscarPerfilUsuario(widget.usuarioId);
  }

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      final File fileImagem = File(imagem.path);

      String? resposta = await PerfilPageService().uploadImagemPerfil(
        widget.usuarioId,
        fileImagem,
      );

      if (resposta != null) {
        setState(() {
          _imagemSelecionada = imagem;
          _carregarDados();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem atualizada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Falha ao enviar imagem')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dadosUsuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar perfil'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Dados não encontrados'));
          }

          final dados = snapshot.data!;
          final nome = dados['nome'] ?? '';
          final telefone = dados['telefone'] ?? '';
          final email = dados['email'] ?? '';
          final cpf = dados['documento'] ?? '';
          final imagemPerfil = dados['imagemPerfil'];
          final imagemUrl = imagemPerfil != null && imagemPerfil != ''
    ? 'http://10.0.2.2:8080/$imagemPerfil?ts=${DateTime.now().millisecondsSinceEpoch}'
    : null;


          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _imagemSelecionada != null
                              ? FileImage(File(_imagemSelecionada!.path))
                              : (imagemUrl != null
                                      ? NetworkImage(imagemUrl)
                                      : const AssetImage('assets/perfil.jpg'))
                                  as ImageProvider,
                      backgroundColor: Colors.grey,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _selecionarImagem,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                InfoCamposPerfil(titulo: "Nome", valor: nome),
                InfoCamposPerfil(titulo: "Telefone", valor: telefone),
                InfoCamposPerfil(titulo: "Email", valor: email),
                InfoCamposPerfil(titulo: "CPF", valor: cpf),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MinhasSolicitacoesPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_alt),
                  label: const Text("Minhas Solicitações"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditarDadosPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar meus dados"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
