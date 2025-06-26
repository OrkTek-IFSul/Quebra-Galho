import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/prestador/pages/adicionar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/denuncias_aceitas_page.dart';
import 'package:quebragalho2/views/prestador/pages/editar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/lista_avaliacoes.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';
import 'package:quebragalho2/views/prestador/widgets/servico_card.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // Para obterIdPrestador()
import 'package:quebragalho2/views/cliente/pages/navegacao_cliente.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic>? prestador;
  bool carregando = true;
  int? idPrestador;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

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

  Future<void> carregarPerfil(int id) async {
    final url = 'https://${ApiConfig.baseUrl}/api/prestador/perfil/$id';
    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Resposta status: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          prestador = decoded;
          carregando = false;
        });
      } else {
        throw Exception(
          'Erro ao carregar perfil. Status: ${response.statusCode}, Corpo: ${response.body}',
        );
      }
    } catch (e, stacktrace) {
      debugPrint('Exceção ao carregar perfil: $e');
      debugPrint('Stacktrace: $stacktrace');
      setState(() {
        carregando = false;
        prestador = {'erro': e.toString()};
      });
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviço desabilitado com sucesso.')),
        );
        await carregarPerfil(idPrestador!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Falha ao desabilitar serviço. Status: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao desabilitar serviço: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao desabilitar serviço: $e')),
      );
    }
  }

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
      builder:
          (context) => AlertDialog(
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
      builder:
          (context) => AlertDialog(
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

    if (prestador == null) {
      return const Scaffold(
        body: Center(child: Text('Erro desconhecido ao carregar perfil.')),
      );
    }

    if (prestador!.containsKey('erro')) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Erro ao carregar perfil:\n\n${prestador!['erro']}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    final nome = prestador?['usuario']['nome'] ?? 'Sem nome';
    final descricao = prestador?['descricao'] ?? '';
    final usuario = prestador?['usuario'];

    final idUsuario = usuario?['id'];
    final imagemPerfil =
        (idUsuario != null)
            ? 'https://${ApiConfig.baseUrl}/api/usuarios/$idUsuario/imagem'
            : '';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      (imagemPerfil.isNotEmpty)
                          ? NetworkImage(imagemPerfil)
                          : null,
                  child:
                      imagemPerfil.isEmpty
                          ? const Icon(Icons.person, size: 40)
                          : null,
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
                        children:
                            tags
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
            // Aqui entra o ListTile customizado
            _buildListTile(
              title: 'Editar meus dados',
              icon: Icons.account_box_outlined,
              onTap: () {
                // ação desejada
                // ação
                _navegarEAtualizar(MeusDados());
              },
              subtitle:
                  'Precisa atualizar alguma informação? Altere seus dados de perfil de forma rápida e segura.',
            ),
            // Linha 'Add Serviços'
            _buildListTile(
              title: 'Adicionar Serviço',
              icon: Icons.build_outlined,
              onTap: () {
                // ação desejada
                // ação
                _navegarEAtualizar(AdicionarServico(idPrestador: idPrestador!));
              },
              subtitle:
                  'Adicione novos serviços para seus clientes em seu perfil.',
            ),

            // Linha 'Migrar prestador'
            _buildListTile(
              title: 'Migrar para cliente',
              icon: Icons.swap_horiz_rounded,
              onTap: () {
                // ação desejada
                // ação
                showMigrarParaClienteDialog(context);
              },
              subtitle:
                  'Mude seu perfil para Cliente, e faça solicitações de serviços pelo app.',
            ),
            _buildListTile(
              title: 'Ver Denúncias Aceitas',
              icon: Icons.report_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DenunciasAceitasPage(idPrestador: idPrestador!),
                  ),
                );
              },
              subtitle: 'Visualize as denúncias aceitas contra seu perfil.',
            ),

            Divider(),
            Expanded(
              child:
                  servicos.isEmpty
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
                            tags: tagsServico, // Passe as tags do serviço aqui
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
                                  tagsServico:
                                      tagsServico
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
