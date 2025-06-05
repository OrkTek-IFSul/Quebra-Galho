import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/prestador/pages/adicionar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/editar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';
import 'package:quebragalho2/views/prestador/widgets/servico_card.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // Para obterIdPrestador()

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
        setState(() {
          prestador = jsonDecode(response.body);
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
        prestador = {
          'erro': e.toString(),
        };
      });
    }
  }

  // Função para navegar e atualizar dados ao voltar
  Future<void> _navegarEAtualizar(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (idPrestador != null) {
      await carregarPerfil(idPrestador!);
    }
  }

  // Função para desabilitar (excluir) serviço via API
  Future<void> desabilitarServico(int idServico) async {
    if (idPrestador == null) return;

    final url = 'https://${ApiConfig.baseUrl}/api/prestador/perfil/desabilitar/$idServico';
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
          SnackBar(content: Text('Falha ao desabilitar serviço. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Erro ao desabilitar serviço: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao desabilitar serviço: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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

    final nome = prestador?['nome'] ?? 'Sem nome';
    final descricao = prestador?['descricao'] ?? '';
    final usuario = prestador?['usuario'];
    final idUsuario = usuario?['id'];
    final imagemPerfil = (idUsuario != null)
        ? 'https://${ApiConfig.baseUrl}/api/usuarios/$idUsuario/imagem'
        : '';

    final List servicos = prestador?['servicos'] ?? [];
    final List tags = prestador?['tags'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
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
                      (imagemPerfil.isNotEmpty) ? NetworkImage(imagemPerfil) : null,
                  child: imagemPerfil.isEmpty
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
                        children: tags
                            .map<Widget>(
                              (tag) => Chip(label: Text(tag['nome'] ?? '')),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          _navegarEAtualizar(MeusDados());
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Meus dados'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Serviços',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (idPrestador != null) {
                      _navegarEAtualizar(AdicionarServico(idPrestador: idPrestador!));
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: servicos.isEmpty
                  ? const Center(child: Text('Nenhum serviço cadastrado.'))
                  : ListView.builder(
                      itemCount: servicos.length,
                      itemBuilder: (context, index) {
                        final servico = servicos[index];
                        return ServicoCard(
                          nome: servico['nome'] ?? '',
                          valor: servico['valor'] ?? 0,
                          onDelete: () {
                            desabilitarServico(servico['id']);
                          },
                          onTap: () {
                            _navegarEAtualizar(
                              EditarServico(
                                idPrestador: idPrestador!,
                                idServico: servico['id'],
                                nomeInicial: servico['nome'] ?? '',
                                descricaoInicial: servico['descricao'] ?? '',
                                valorInicial: servico['valor'] ?? 0,
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
