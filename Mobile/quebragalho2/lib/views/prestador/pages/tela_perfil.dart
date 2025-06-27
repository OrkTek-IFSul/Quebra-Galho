import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // Para obterIdPrestador()
import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';
import 'package:quebragalho2/views/prestador/pages/adicionar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/editar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/lista_avaliacoes.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';
import 'package:quebragalho2/views/prestador/widgets/servico_card.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic>? prestador;
  bool carregando = true;
  int? idPrestador;
  XFile? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  // --- MÉTODOS DE API E LÓGICA INTERNA ---

  /// Busca os dados do perfil do prestador na API.
  Future<Map<String, dynamic>> _buscarPerfilApi(int prestadorId) async {
    final url = 'https://${ApiConfig.baseUrl}/api/prestador/perfil/$prestadorId';
    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Resposta status: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
            'Erro ao carregar perfil. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exceção ao carregar perfil: $e');
      throw Exception('Exceção ao carregar perfil: $e');
    }
  }

  /// Faz o upload da imagem de perfil para a API.
  Future<String?> _uploadImagemApi(int usuarioId, File imagem) async {
    final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$usuarioId/imagem');
    final request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(imagem.path) ?? 'image/jpeg';
    final fileStream = await http.MultipartFile.fromPath(
      'file',
      imagem.path,
      contentType: MediaType.parse(mimeType),
    );

    request.files.add(fileStream);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final resposta = await response.stream.bytesToString();
        return resposta;
      } else {
        debugPrint('Erro ao fazer upload: ${response.statusCode}');
        final errorBody = await response.stream.bytesToString();
        debugPrint('Corpo do erro: $errorBody');
        return null;
      }
    } catch (e) {
      debugPrint('Exceção no upload: $e');
      return null;
    }
  }

  /// Carrega os dados iniciais, incluindo o ID do prestador.
  Future<void> carregarDados() async {
    final id = await obterIdPrestador();
    if (id != null) {
      setState(() {
        idPrestador = id;
      });
      await carregarPerfil(id);
    } else {
      setState(() {
        carregando = false;
        prestador = {'erro': 'ID do prestador não encontrado.'};
      });
    }
  }

  /// Carrega o perfil usando o método da API.
  Future<void> carregarPerfil(int id) async {
    try {
      final data = await _buscarPerfilApi(id);
      if (mounted) {
        setState(() {
          prestador = data;
          carregando = false;
        });
      }
    } catch (e) {
       if (mounted) {
        setState(() {
          carregando = false;
          prestador = {'erro': e.toString()};
        });
      }
    }
  }

  /// Seleciona uma imagem da galeria e inicia o upload.
  Future<void> _selecionarEUploadImagem() async {
    if (idPrestador == null) return;
    final int? idUsuario = prestador?['usuario']?['id'];
    if (idUsuario == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID do usuário não encontrado para upload.')),
        );
      }
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      final File fileImagem = File(imagem.path);

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enviando imagem...')),
        );
      }

      String? resposta = await _uploadImagemApi(idUsuario, fileImagem);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (resposta != null) {
          setState(() {
            _imagemSelecionada = imagem;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagem atualizada com sucesso!')),
          );
          await carregarPerfil(idPrestador!);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao enviar imagem.')));
        }
      }
    }
  }

  Future<void> _navegarEAtualizar(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (idPrestador != null) {
      await carregarPerfil(idPrestador!);
    }
  }

  Future<void> desabilitarServico(int idServico) async {
    if (idPrestador == null) return;

    final url =
        'https://${ApiConfig.baseUrl}/api/prestador/perfil/desabilitar/$idServico';
    try {
      final response = await http.put(Uri.parse(url));
      debugPrint('Desabilitar serviço status: ${response.statusCode}');
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço desabilitado com sucesso.')),
          );
        }
        await carregarPerfil(idPrestador!);
      } else {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Falha ao desabilitar serviço. Status: ${response.statusCode}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao desabilitar serviço: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao desabilitar serviço: $e')),
        );
      }
    }
  }

  // --- WIDGETS E UI ---

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
                color: const Color.fromARGB(255, 231, 231, 231),
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

  Future<void> showMigrarParaClienteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar para Cliente'),
        content: const Text('Deseja alterar para sua conta de cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('NÃO'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SIM'),
          ),
        ],
      ),
    );

    if (result == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const NavegacaoCliente()),
        (route) => false,
      );
    }
  }

  void _showConfirmDeleteDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover serviço'),
        content: const Text('Tem certeza que deseja remover?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (prestador == null || prestador!.containsKey('erro')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Erro ao carregar perfil:\n\n${prestador?['erro'] ?? 'Erro desconhecido.'}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    
    final nome = prestador?['usuario']['nome'] ?? 'Sem nome';
    final descricao = prestador?['descricao'] ?? '';
    final usuario = prestador?['usuario'];

    final idUsuario = usuario?['id'];
    
    final imagemUrl = (idUsuario != null)
        ? 'https://${ApiConfig.baseUrl}/api/usuarios/$idUsuario/imagem?ts=${DateTime.now().millisecondsSinceEpoch}'
        : null;


    final List servicos = prestador?['servicos'] ?? [];
    final List tags = prestador?['tags'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            tooltip: 'Ver feedbacks',
            onPressed: idPrestador == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListaAvaliacoesPage(idPrestador: idPrestador!),
                      ),
                    );
                  },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _imagemSelecionada != null
                          ? FileImage(File(_imagemSelecionada!.path))
                          : (imagemUrl != null
                              ? NetworkImage(imagemUrl)
                              : const AssetImage('assets/perfil.jpg'))
                                  as ImageProvider,
                    ),
                    GestureDetector(
                      onTap: _selecionarEUploadImagem,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (descricao.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(descricao),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: tags
                            .map<Widget>(
                              (tag) => Chip(label: Text(tag['nome'] ?? '')),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildListTile(
              title: 'Editar meus dados',
              icon: Icons.account_box_outlined,
              onTap: () {
                _navegarEAtualizar(MeusDados());
              },
              subtitle:
                  'Precisa atualizar alguma informação? Altere seus dados de perfil de forma rápida e segura.',
            ),
            _buildListTile(
              title: 'Adicionar Serviço',
              icon: Icons.build_outlined,
              onTap: () {
                _navegarEAtualizar(AdicionarServico(idPrestador: idPrestador!));
              },
              subtitle:
                  'Adicione novos serviços para seus clientes em seu perfil.',
            ),
            _buildListTile(
              title: 'Migrar para cliente',
              icon: Icons.swap_horiz_rounded,
              onTap: () {
                showMigrarParaClienteDialog(context);
              },
              subtitle:
                  'Mude seu perfil para Cliente, e faça solicitações de serviços pelo app.',
            ),
            const Divider(),
            Expanded(
              child: servicos.isEmpty
                  ? const Center(child: Text('Nenhum serviço cadastrado.'))
                  : ListView.builder(
                      itemCount: servicos.length,
                      itemBuilder: (context, index) {
                        final servico = servicos[index];
                        final List tagsServico = servico['tags'] ?? [];

                        return ServicoCard(
                          nome: servico['nome'] ?? '',
                          valor: servico['preco']?.toDouble() ?? 0,
                          duracao: servico['duracao'] ?? 0,
                          descricao: servico['descricao'] ?? '',
                          tags: tagsServico,
                          onDelete: () {
                            _showConfirmDeleteDialog(context, () {
                              desabilitarServico(servico['id']);
                            });
                          },
                          onTap: () {
                            _navegarEAtualizar(
                              EditarServico(
                                idPrestador: idPrestador!,
                                idServico: servico['id'],
                                nomeInicial: servico['nome'] ?? '',
                                descricaoInicial: servico['descricao'] ?? '',
                                valorInicial:
                                    servico['preco']?.toDouble() ?? 0,
                                duracao: servico['duracao'] ?? 0,
                                tagsServico: tagsServico
                                    .map<int>((tag) => tag['id'] as int)
                                    .toList(),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
