import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quebragalho2/services/perfil_page_services.dart';
import 'package:quebragalho2/views/cliente/pages/editar_dados_page.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
import 'package:quebragalho2/views/cliente/pages/minhas_solicitacoes_page.dart';
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/widgets/modal_cadastro_prestador.dart';
import 'package:quebragalho2/views/cliente/widgets/dialog_migrar_prestador.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:quebragalho2/views/prestador/pages/navegacao_prestador.dart'; // Importação da tela de navegação do prestador


class PerfilPage extends StatefulWidget {
  final int usuarioId;
  const PerfilPage({super.key, required this.usuarioId});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Future<Map<String, dynamic>>? _dadosUsuario;
  XFile? _imagemSelecionada;
  int? idP;

  // Máscara para o telefone
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

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _obterIdPrestador();
  }

  void _carregarDados() {
    setState(() {
      _dadosUsuario = PerfilPageService().buscarPerfilUsuario(widget.usuarioId);
    });
  }

  Future<void> _obterIdPrestador() async {
    idP = await obterIdPrestador();
    setState(() {}); // Atualiza o estado para refletir o idP
  }

  // --- MÉTODOS DE LÓGICA (permanecem inalterados) ---
  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      final File fileImagem = File(imagem.path);
      String? resposta = await PerfilPageService().uploadImagemPerfil(
        widget.usuarioId,
        fileImagem,
      );

      if (mounted) {
        if (resposta != null) {
          setState(() {
            _imagemSelecionada = imagem;
            _carregarDados(); // Recarrega os dados para obter a nova URL da imagem
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagem atualizada com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao enviar imagem')));
        }
      }
    }
  }

  Future<bool> _verificarPrestador(int usuarioId) async {
    try {
      final url =
          Uri.parse('https://${ApiConfig.baseUrl}/api/tipousuario/$usuarioId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = response.body.trim().toLowerCase();
        return result == 'true';
      }
    } catch (_) {}
    return false;
  }
  
  // --- WIDGETS DE LAYOUT (ATUALIZADOS) ---

  // NOVO: Widget para os itens da lista de opções
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.grey.shade800, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NOVO: Widget para os campos de informação (Email e Telefone)
  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color.fromARGB(255, 167, 167, 167),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dadosUsuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar perfil: ${snapshot.error}'));
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Dados não encontrados'));
          }

          final dados = snapshot.data!;
          final nome = dados['nome'] ?? 'Nome não informado';
          final telefoneRaw = dados['telefone'] ?? '';
          final email = dados['email'] ?? 'E-mail não informado';
          final cpfRaw = dados['documento'] ?? '';
          final imagemPerfil = dados['imagemPerfil'];

          // Adiciona um timestamp para evitar problemas de cache com a imagem
          final imageUrl = (imagemPerfil != null && imagemPerfil.isNotEmpty)
              ? 'https://${ApiConfig.baseUrl}/$imagemPerfil?ts=${DateTime.now().millisecondsSinceEpoch}'
              : null;
          
          // Formata o telefone e CPF com as máscaras
          final telefoneFormatado = _maskTelefone.maskText(telefoneRaw);
          final cpfFormatado = _maskCpf.maskText(cpfRaw);


          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // --- CABEÇALHO DO PERFIL ---
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _imagemSelecionada != null
                            ? FileImage(File(_imagemSelecionada!.path))
                            : (imageUrl != null
                                ? NetworkImage(imageUrl)
                                : const AssetImage('assets/perfil.jpg'))
                                    as ImageProvider,
                      ),
                      GestureDetector(
                        onTap: _selecionarImagem,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black87,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CPF: $cpfFormatado',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn("Email", email),
                      _buildInfoColumn("Telefone", telefoneFormatado),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1),

                  // --- LISTA DE OPÇÕES ---
                  _buildListTile(
                    icon: Icons.list_alt_rounded,
                    title: "Minhas solicitações",
                    subtitle:
                        "Encontre todas as suas solicitações já feitas. Acompanhe o status e veja os detalhes.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MinhasSolicitacoesPage(),
                        ),
                      );
                    },
                  ),
                  _buildListTile(
                    icon: Icons.person_outline_rounded,
                    title: "Editar meus dados",
                    subtitle:
                        "Precisa atualizar alguma informação? Altere seus dados de perfil de forma rápida e segura.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarDadosPage(),
                        ),
                      ).then((_) => _carregarDados());
                    },
                  ),
                  
                  
                  _buildListTile(
                    title: 'Migrar para prestador',
                    icon: Icons.swap_horiz,
                    subtitle:
                        "Altere para conta do modo prestador para acessar novas funções e poder oferecer serviços",
                    onTap: () async {
                      final isPrestador = await _verificarPrestador(widget.usuarioId);
                      if (isPrestador) {
                        final idPrestador = await obterIdPrestador();
                        if (idPrestador != null && context.mounted) {
                          showMigrarParaPrestadorDialog(context, idPrestador);
                        }
                      } else {
                        showCadastroPrestadorModal(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
