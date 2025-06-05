import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quebragalho2/services/perfil_page_services.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';
import 'package:quebragalho2/views/cliente/pages/minhas_solicitacoes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/info_campos_perfil.dart';
import 'package:quebragalho2/api_config.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key}); // Sem parâmetro usuarioId

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int? _usuarioId; // Aqui não é Future mais
  Future<Map<String, dynamic>>? _dadosUsuario;
  XFile? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarUsuarioId();
  }

  Future<void> _carregarUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('usuario_id');
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: usuário não está logado')),
      );
      return;
    }
    setState(() {
      _usuarioId = id;
      _dadosUsuario = PerfilPageService().buscarPerfilUsuario(id);
    });
  }

  void _carregarDados() {
    if (_usuarioId == null) return;
    setState(() {
      _dadosUsuario = PerfilPageService().buscarPerfilUsuario(_usuarioId!);
    });
  }

  Future<void> _selecionarImagem() async {
    if (_usuarioId == null) return;
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      final File fileImagem = File(imagem.path);

      String? resposta = await PerfilPageService().uploadImagemPerfil(
        _usuarioId!,
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao enviar imagem')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_usuarioId == null) {
      // Enquanto carrega o ID, mostra loading
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        automaticallyImplyLeading: false,
      ),
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
          final imagemUrl = (imagemPerfil != null && imagemPerfil != '')
              ? 'https://${ApiConfig.baseUrl}/$imagemPerfil?ts=${DateTime.now().millisecondsSinceEpoch}'
              : null;


          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imagemSelecionada != null
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
                        builder: (context) => EditarDadosPage(),
                      ),
                    ).then((_) {
                      // Atualiza os dados ao voltar da tela de edição
                      _carregarDados();
                    });
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
