import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/moderador/detalhes_apelo_page.dart';
import 'package:quebragalho2/views/moderador/detalhes_denuncia_page.dart';
import 'package:quebragalho2/views/moderador/detalhes_prestador_page.dart';

enum ListaTipo { usuarios, prestadores, denuncias, apelos }

class ModeradorPage extends StatefulWidget {
  const ModeradorPage({super.key});

  @override
  State<ModeradorPage> createState() => _ModeracaoPageState();
}

class _ModeracaoPageState extends State<ModeradorPage> {
  ListaTipo listaSelecionada = ListaTipo.usuarios;

  List<dynamic> usuarios = [];
  List<dynamic> prestadores = [];
  List<dynamic> denuncias = [];
  List<dynamic> apelos = [];

  String filtroPesquisa = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _searchController.addListener(() {
      setState(() {
        filtroPesquisa = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _carregarDados() async {
    await fetchUsuarios();
    await fetchPrestadores();
    await fetchDenuncias();
    await fetchApelos();
  }

  Future<void> fetchUsuarios() async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/listarUsuarios',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          usuarios = json['content'] ?? [];
        });
      } else {
        print('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    }
  }

  Future<void> fetchPrestadores() async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/analisarPrestador',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          prestadores = json; // Aqui está a correção!
        });
      } else {
        print('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar prestadores: $e');
    }
  }

  Future<void> fetchDenuncias() async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/analisarDenuncias',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Filtro: apenas denúncias com status null (pendentes)
        final List<dynamic> pendentes =
            data.where((denuncia) => denuncia['status'] == null).toList();

        setState(() {
          denuncias = pendentes;
        });
      } else {
        print('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar denúncias: $e');
    }
  }

  Future<void> fetchApelos() async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/analisarApelos',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        // decodifica direto como List
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          apelos = data;
        });
      } else {
        print('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar apelos: $e');
    }
  }

  Future<void> _atualizarModerador(int idUsuario, bool ehModerador) async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/${ehModerador ? "removerModerador" : "tornarModerador"}/$idUsuario',
    );

    try {
      final response = await http.put(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ehModerador
                  ? 'Moderador removido com sucesso'
                  : 'Usuário promovido a moderador',
            ),
          ),
        );
        await fetchUsuarios(); // Atualiza a lista
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
    }
  }

  Widget _buildBotao(String texto, ListaTipo tipo) {
    final selecionado = listaSelecionada == tipo;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selecionado ? Colors.purple : Colors.grey[300],
          foregroundColor: selecionado ? Colors.white : Colors.black,
        ),
        onPressed: () {
          setState(() => listaSelecionada = tipo);
        },
        child: Text(texto),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Pesquisar...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildListaAtiva() {
    switch (listaSelecionada) {
      case ListaTipo.usuarios:
        final filtrados =
            usuarios.where((u) {
              final nome = u['nome']?.toString().toLowerCase() ?? '';
              final email = u['email']?.toString().toLowerCase() ?? '';
              return nome.contains(filtroPesquisa) ||
                  email.contains(filtroPesquisa);
            }).toList();

        return _buildLista(
          filtrados,
          (item) => ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://${ApiConfig.baseUrl}/${item['imgPerfil']}',
              ),
            ),
            title: Text(item['nome'] ?? 'Sem nome'),
            subtitle: Text(
              'Email: ${item['email'] ?? '---'}\n'
              'Telefone: ${item['telefone'] ?? '---'}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['moderador'] ? 'Moderador' : 'Usuário'),
                const SizedBox(height: 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        item['moderador'] ? Colors.red : Colors.green,
                  ),
                  onPressed:
                      () => _atualizarModerador(item['id'], item['moderador']),
                  child: Text(item['moderador'] ? 'Remover' : 'Tornar'),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );

      case ListaTipo.prestadores:
        return _buildLista(
          prestadores,
          (item) => ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://${ApiConfig.baseUrl}/${item['imgDocumento']}',
              ),
            ),
            title: Text(item['descricao'] ?? 'Sem descrição'),
            subtitle: Text(
              'Usuário: ${item['usuario']?['nome'] ?? '---'}\n'
              'Email: ${item['usuario']?['email'] ?? '---'}',
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            DetalhesPrestadorPage(idPrestador: item['id']),
                  ),
                );
              },
              child: const Text("Selecionar"),
            ),
            isThreeLine: true,
          ),
        );

      case ListaTipo.denuncias:
        return _buildLista(
          denuncias,
          (item) => ListTile(
            title: Text('Motivo: ${item['motivo'] ?? '---'}'),
            subtitle: Text('Tipo: ${item['tipo'] ?? '---'}'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesDenunciaPage(denuncia: item),
                  ),
                );
              },

              child: const Text("Selecionar"),
            ),
          ),
        );

      case ListaTipo.apelos:
        return _buildLista(apelos, (item) {
          final apeloId = item['apeloId'];
          final justificativa = item['justificativa'] ?? '—';
          final status =
              item['status'] == null
                  ? 'Pendente'
                  : (item['status'] == true ? 'Aceito' : 'Recusado');
          final denuncia = item['denuncia'] as Map<String, dynamic>;

          return ListTile(
            title: Text('Apelo #$apeloId'),
            subtitle: Text(
              'Justificativa: $justificativa\n'
              'Status: $status',
            ),
            isThreeLine: true,
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalhesApeloPage(apelo: item),
                  ),
                );
              },
              child: const Text("Selecionar"),
            ),
          );
        });
    }
  }

  Widget _buildLista(
    List<dynamic> dados,
    Widget Function(dynamic) itemBuilder,
  ) {
    if (dados.isEmpty)
      return const Center(child: Text('Nenhum item encontrado.'));
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dados.length,
      itemBuilder: (context, index) => Card(child: itemBuilder(dados[index])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel de Moderação')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                _buildBotao("Usuários", ListaTipo.usuarios),
                const SizedBox(width: 8),
                _buildBotao("Prestadores", ListaTipo.prestadores),
              ],
            ),
            Row(
              children: [
                _buildBotao("Denúncias", ListaTipo.denuncias),
                const SizedBox(width: 8),
                _buildBotao("Apelos", ListaTipo.apelos),
              ],
            ),

            const SizedBox(height: 12),
            if (listaSelecionada == ListaTipo.usuarios) _buildSearchBar(),
            const SizedBox(height: 8),
            Expanded(child: SingleChildScrollView(child: _buildListaAtiva())),
          ],
        ),
      ),
    );
  }
}
