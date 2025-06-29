// imports permanecem os mesmos
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';
import 'package:quebragalho2/views/prestador/pages/adicionar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/editar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/lista_avaliacoes.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';
import 'package:quebragalho2/views/prestador/pages/adicionar_portfolio.dart';
import 'package:quebragalho2/views/prestador/pages/denuncias_aceitas_page.dart';
import 'package:quebragalho2/views/prestador/widgets/servico_card.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // obterIdPrestador

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
  List<Map<String, dynamic>> portfolio = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final id = await obterIdPrestador();
    if (id != null) {
      setState(() => idPrestador = id);
      await carregarPerfil(id);
      await carregarPortfolio(id);
    } else {
      setState(() {
        carregando = false;
        prestador = {'erro': 'ID do prestador não encontrado.'};
      });
    }
  }

  Future<void> carregarPerfil(int id) async {
    final url = 'https://${ApiConfig.baseUrl}/api/prestador/perfil/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          prestador = jsonDecode(utf8.decode(response.bodyBytes));
          carregando = false;
        });
      } else {
        setState(() {
          prestador = {'erro': 'Erro ${response.statusCode}'};
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        prestador = {'erro': 'Exceção: $e'};
        carregando = false;
      });
    }
  }

  Future<void> carregarPortfolio(int id) async {
    final url = 'https://${ApiConfig.baseUrl}/api/portfolio/prestador/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          portfolio = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar portfólio: $e");
    }
  }

  Future<void> excluirImagemPortfolio(int idImagem) async {
    final url = 'https://${ApiConfig.baseUrl}/api/portfolio/$idImagem';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 204) {
        setState(() {
          portfolio.removeWhere((img) => img['id'] == idImagem);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagem removida com sucesso.')),
          );
        }
      } else {
        throw Exception('Erro ao excluir imagem.');
      }
    } catch (e) {
      debugPrint('Erro ao excluir imagem: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao remover imagem.')),
        );
      }
    }
  }

  void _confirmarExcluirImagem(int idImagem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover imagem'),
        content: const Text('Deseja remover esta imagem do portfólio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              excluirImagemPortfolio(idImagem);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  Future<void> showMigrarParaClienteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(
                'Alterar para Cliente',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            content: const Text(
              'Deseja migrar para sua \nconta de cliente?',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('NÃO', style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'SIM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

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
      return response.statusCode == 200
          ? await response.stream.bytesToString()
          : null;
    } catch (e) {
      debugPrint('Erro upload: $e');
      return null;
    }
  }

  Future<void> _selecionarEUploadImagem() async {
    if (idPrestador == null) return;
    final idUsuario = prestador?['usuario']?['id'];
    if (idUsuario == null) return;

    final picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      final file = File(imagem.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enviando imagem...')),
      );
      final resposta = await _uploadImagemApi(idUsuario, file);
      if (resposta != null) {
        setState(() => _imagemSelecionada = imagem);
        await carregarPerfil(idPrestador!);
      }
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  Future<void> _navegarEAtualizar(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (idPrestador != null) {
      await carregarPerfil(idPrestador!);
      await carregarPortfolio(idPrestador!);
    }
  }

  Future<void> desabilitarServico(int idServico) async {
    final url = 'https://${ApiConfig.baseUrl}/api/prestador/perfil/desabilitar/$idServico';
    try {
      final response = await http.put(Uri.parse(url));
      if (response.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviço desabilitado.')),
        );
        await carregarPerfil(idPrestador!);
      }
    } catch (e) {
      debugPrint("Erro ao desabilitar: $e");
    }
  }

  void showMigrarParaClienteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Center(
              child: Text(
                'Removendo serviço',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            content: const Text(
              'Tem certeza que deseja remover?',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('NÃO', style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                child: const Text('SIM', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
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
        body: Center(
          child: Text('Erro: ${prestador?['erro'] ?? 'Erro desconhecido.'}'),
        ),
      );
    }

    final nome = prestador?['usuario']['nome'] ?? '';
    final descricao = prestador?['descricao'] ?? '';
    final idUsuario = prestador?['usuario']?['id'];
    final imagemUrl = idUsuario != null
        ? 'https://${ApiConfig.baseUrl}/api/usuarios/$idUsuario/imagem?ts=${DateTime.now().millisecondsSinceEpoch}'
        : null;
    final servicos = prestador?['servicos'] ?? [];
    final tags = prestador?['tags'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            tooltip: 'Ver feedbacks',
            onPressed:
                idPrestador == null
                    ? null
                    : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ListaAvaliacoesPage(
                                idPrestador: idPrestador!,
                              ),
                        ),
                      );
                    },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar e dados básicos
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _imagemSelecionada != null
                        ? FileImage(File(_imagemSelecionada!.path))
                        : (imagemUrl != null
                            ? NetworkImage(imagemUrl)
                            : const AssetImage('assets/perfil.jpg')) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _selecionarEUploadImagem,
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.edit, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(descricao),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: tags
                          .map<Widget>((tag) => Chip(label: Text(tag['nome'] ?? '')))
                          .toList(),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navegarEAtualizar(const PortfolioUploadPage()),
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text("Adicionar ao Portfólio"),
          ),
          const SizedBox(height: 16),
          if (portfolio.isNotEmpty) ...[
            const Text("Meu Portfólio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: portfolio.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final imagem = portfolio[index];
                final imagemUrl = 'https://${ApiConfig.baseUrl}${imagem['imagemUrl']}';
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(imagemUrl, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _confirmarExcluirImagem(imagem['id']),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
          _buildListTile(
            title: 'Editar meus dados',
            icon: Icons.account_box_outlined,
            onTap: () => _navegarEAtualizar(MeusDados()),
            subtitle: 'Atualize seu perfil de forma rápida e segura.',
          ),
          _buildListTile(
            title: 'Adicionar Serviço',
            icon: Icons.build_outlined,
            onTap: () => _navegarEAtualizar(AdicionarServico(idPrestador: idPrestador!)),
            subtitle: 'Adicione novos serviços ao seu perfil.',
          ),
          _buildListTile(
            title: 'Ver Denúncias Aceitas',
            icon: Icons.report_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DenunciasAceitasPage(idPrestador: idPrestador!),
              ),
            ),
            subtitle: 'Visualize as denúncias aceitas contra seu perfil.',
          ),
          _buildListTile(
            title: 'Migrar para cliente',
            icon: Icons.swap_horiz_rounded,
            onTap: () => showMigrarParaClienteDialog(context),
            subtitle: 'Mude para perfil Cliente e solicite serviços.',
          ),
          const Divider(height: 32),
          Text("Serviços cadastrados",
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (servicos.isEmpty)
            const Text("Nenhum serviço cadastrado."),
          ...servicos.map<Widget>((servico) {
            final tagsServico = servico['tags'] ?? [];
            return ServicoCard(
              nome: servico['nome'] ?? '',
              valor: servico['preco']?.toDouble() ?? 0,
              duracao: servico['duracao'] ?? 0,
              descricao: servico['descricao'] ?? '',
              tags: tagsServico,
              onDelete: () => desabilitarServico(servico['id']),
              onTap: () => _navegarEAtualizar(EditarServico(
                idPrestador: idPrestador!,
                idServico: servico['id'],
                nomeInicial: servico['nome'],
                descricaoInicial: servico['descricao'],
                valorInicial: servico['preco']?.toDouble() ?? 0,
                duracao: servico['duracao'],
                tagsServico: tagsServico.map<int>((tag) => tag['id'] as int).toList(),
              )),
            );
          }).toList(),
        ],
      ),
    );
  }
}
