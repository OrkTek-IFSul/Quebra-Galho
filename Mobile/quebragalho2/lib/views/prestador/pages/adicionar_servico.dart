import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';

class AdicionarServico extends StatefulWidget {
  final int idPrestador;

  const AdicionarServico({
    super.key,
    required this.idPrestador,
  });

  @override
  State<AdicionarServico> createState() => _AdicionarServicoState();
}

class _AdicionarServicoState extends State<AdicionarServico> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController duracaoController = TextEditingController();

  List<Map<String, dynamic>> tagsDisponiveis = [];
  final Set<int> tagsSelecionadas = {};

  bool _isLoading = false;
  bool _loadingTags = true;

  @override
  void initState() {
    super.initState();
    _carregarTags();
  }

  Future<void> _carregarTags() async {
    final uri = Uri.http(ApiConfig.baseUrl, '/api/usuario/homepage/tags');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          tagsDisponiveis = data.cast<Map<String, dynamic>>();
          _loadingTags = false;
        });
      } else {
        setState(() => _loadingTags = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao carregar tags (${response.statusCode})')),
        );
      }
    } catch (e) {
      setState(() => _loadingTags = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar tags: $e')),
      );
    }
  }

  Future<void> _salvarServico() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = nomeController.text.trim();
    final descricao = descricaoController.text.trim();
    final valorText = valorController.text.trim().replaceAll(',', '.');
    final valor = double.tryParse(valorText);
    final duracao = int.tryParse(duracaoController.text.trim());

    if (valor == null || duracao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe valor e duração válidos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final tagsJson = tagsSelecionadas.map((id) {
      final tag = tagsDisponiveis.firstWhere((t) => t['id'] == id);
      return {'id': tag['id'], 'nome': tag['nome']};
    }).toList();

    try {
      final response = await http.post(
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/servico/${widget.idPrestador}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'descricao': descricao,
          'preco': valor,
          'duracaoMinutos': duracao,
          'tags': tagsJson,
          'prestador': {'id': widget.idPrestador},
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Serviço "$nome" adicionado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception('Falha ao adicionar serviço (status: ${response.statusCode})');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar serviço: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrição', alignLabelWithHint: true),
                validator: (v) => (v == null || v.isEmpty) ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Valor: R\$'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: valorController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: 'Ex: 123.45'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe o valor';
                        return double.tryParse(v.replaceAll(',', '.')) == null
                            ? 'Valor inválido'
                            : null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Duração (min):'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: duracaoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Ex: 90'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe a duração';
                        return int.tryParse(v) == null ? 'Duração inválida' : null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (_loadingTags)
                const Center(child: CircularProgressIndicator())
              else if (tagsDisponiveis.isEmpty)
                const Text('Nenhuma tag disponível.')
              else
                ...tagsDisponiveis.map((tag) {
                  return CheckboxListTile(
                    title: Text(tag['nome']),
                    value: tagsSelecionadas.contains(tag['id']),
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          tagsSelecionadas.add(tag['id']);
                        } else {
                          tagsSelecionadas.remove(tag['id']);
                        }
                      });
                    },
                  );
                }),
              const SizedBox(height: 24),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _salvarServico,
                        child: const Text('Adicionar'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
