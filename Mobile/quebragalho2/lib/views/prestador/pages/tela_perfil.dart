import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/prestador/pages/adicionar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/editar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/meus_dados.dart';
import 'package:quebragalho2/views/prestador/widgets/servico_card.dart';

// Página de perfil do prestador
class PerfilPage extends StatefulWidget {
  final int idPrestador;

  const PerfilPage({super.key, required this.idPrestador});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic>? prestador;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  // Faz requisição HTTP para obter os dados do prestador
  Future<void> carregarPerfil() async {
    final url = 'http://192.168.1.24:8080/api/prestador/perfil/${widget.idPrestador}';
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

    // Dados do prestador
    final nome = prestador?['nome'] ?? 'Sem nome';
    final descricao = prestador?['descricao'] ?? '';
    final usuario = prestador?['usuario'];
    final idUsuario = usuario?['id'];
    final imagemPerfil = (usuario != null && usuario['id'] != null)
    ? 'http://192.168.1.24:8080/api/usuarios/${usuario['id']}/imagem'
    : '';

    final List servicos = prestador?['servicos'] ?? [];
    final List tags = prestador?['tags'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cabeçalho com foto, nome, descrição e botão "Meus dados"
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: (imagemPerfil.isNotEmpty)
                      ? NetworkImage(imagemPerfil)
                      : null,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeusDados(),
                            ),
                          );
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

            // Título "Serviços" com botão de adicionar serviço
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Serviços',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //ALTERAR PARA ID DO PRESTADOR QUE ESTÁ LOGADO
                        builder: (context) => AdicionarServico(idPrestador: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Lista de serviços
            Expanded(
              child: servicos.isEmpty
                  ? const Center(child: Text('Nenhum serviço cadastrado.'))
                  : ListView.builder(
                      itemCount: servicos.length,
                      itemBuilder: (context, index) {
                        final servico = servicos[index];
                        return ServicoCard(
                          nome: servico['nome'] ?? '',
                          valor: 0, // Atualize com valor real se necessário
                          onDelete: () {
                            setState(() {
                              servicos.removeAt(index);
                            });
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarServico(
                                  nomeInicial: servico['nome'] ?? '',
                                  descricaoInicial:
                                      'Descrição não carregada da API',
                                  valorInicial: 0,
                                ),
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
