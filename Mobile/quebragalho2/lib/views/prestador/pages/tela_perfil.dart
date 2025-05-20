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
    carregarPerfil(); // Carrega os dados do prestador ao iniciar a tela
  }

  // Faz requisição HTTP para obter os dados do prestador
  Future<void> carregarPerfil() async {
    final url = 'http://192.168.1.8:8080/api/prestadores/${widget.idPrestador}';
    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Resposta status: ${response.statusCode}');
      debugPrint('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        // Se sucesso, atualiza o estado com os dados do prestador
        setState(() {
          prestador = jsonDecode(response.body);
          carregando = false;
        });
      } else {
        // Erro no status da resposta
        throw Exception(
          'Erro ao carregar perfil. Status: ${response.statusCode}, Corpo: ${response.body}',
        );
      }
    } catch (e, stacktrace) {
      // Em caso de exceção, exibe mensagem de erro
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
    // Enquanto os dados estão sendo carregados
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Caso prestador seja nulo
    if (prestador == null) {
      return const Scaffold(
        body: Center(child: Text('Erro desconhecido ao carregar perfil.')),
      );
    }

    // Caso ocorra erro ao carregar os dados
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

    // Extrai os dados do prestador
    final nome = prestador?['nome'] ?? 'Sem nome';
    final descricao = prestador?['descricao'] ?? '';
    final imagemPerfil = prestador?['imagemPerfilUrl'] ?? '';
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
                      // Nome
                      Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Descrição se houver
                      if (descricao.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(descricao),
                      ],
                      const SizedBox(height: 8),
                      // Tags do prestador
                      Wrap(
                        spacing: 8,
                        children: tags
                            .map<Widget>(
                              (tag) => Chip(label: Text(tag['nome'] ?? '')),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      // Botão que leva à tela de edição dos dados do prestador
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
                        builder: (context) => AdicionarServico(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Lista de serviços do prestador
            Expanded(
              child: servicos.isEmpty
                  ? const Center(child: Text('Nenhum serviço cadastrado.'))
                  : ListView.builder(
                      itemCount: servicos.length,
                      itemBuilder: (context, index) {
                        final servico = servicos[index];
                        return ServicoCard(
                          nome: servico['nome'] ?? '',
                          valor: 0, // Substitua se o valor vier da API
                          onDelete: () {
                            // Remove da lista local
                            setState(() {
                              servicos.removeAt(index);
                            });
                          },
                          onTap: () {
                            // Navega para a tela de edição do serviço
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
