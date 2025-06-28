import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';

class AdicionarServico extends StatefulWidget {
  final int idPrestador;

  const AdicionarServico({super.key, required this.idPrestador});

  @override
  State<AdicionarServico> createState() => _AdicionarServicoState();
}

class _AdicionarServicoState extends State<AdicionarServico> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController duracaoController = TextEditingController(text: '30');

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
    final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/tags');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          tagsDisponiveis = data.cast<Map<String, dynamic>>();
          _loadingTags = false;
        });
      } else {
        setState(() => _loadingTags = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao carregar tags (${response.statusCode})')),
          );
        }
      }
    } catch (e) {
      setState(() => _loadingTags = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar tags: $e')),
        );
      }
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

    final url = Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/servico/${widget.idPrestador}');

    final body = json.encode({
      'nome': nome,
      'descricao': descricao,
      'preco': valor,
      'duracaoMinutos': duracao,
      'idPrestador': widget.idPrestador,
      'tags': tagsJson,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Serviço "$nome" adicionado com sucesso!')),
          );
          Navigator.pop(context, true);
        }
      } else {
        final errorMessage = responseBody['message'] ?? 'Erro desconhecido';
        throw Exception(
            'Falha ao adicionar serviço (Status: ${response.statusCode}) - $errorMessage');
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
    void _showAddTagDialog() {
      final tagsParaAdicionar = tagsDisponiveis
          .where((tag) => !tagsSelecionadas.contains(tag['id']))
          .toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Adicionar Tag'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tagsParaAdicionar.length,
                itemBuilder: (BuildContext context, int index) {
                  final tag = tagsParaAdicionar[index];
                  return ListTile(
                    title: Text(tag['nome']),
                    onTap: () {
                      setState(() {
                        if (tagsSelecionadas.length < 3) {
                          tagsSelecionadas.add(tag['id']);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Você pode adicionar no máximo 3 tags.'),
                            ),
                          );
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      errorStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Adicionar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : IconButton(
                          icon: const Icon(Icons.check, color: Colors.black, size: 30),
                          onPressed: _salvarServico,
                        ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nomeController,
                        maxLength: 45,
                        decoration: inputDecoration.copyWith(
                          hintText: 'Ex: Instalação de Ar-condicionado',
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Informe o nome';
                          if (v.trim().length > 45) return 'Máximo de 45 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: descricaoController,
                        maxLength: 250,
                        decoration: inputDecoration.copyWith(
                          hintText: 'Descreva os detalhes do serviço...',
                          counterText: '',
                        ),
                        maxLines: 2,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Informe a descrição';
                          if (v.trim().length > 250) return 'Máximo de 250 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Divider(),
                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Duração (Minutos)', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: duracaoController.text.isEmpty ? '30' : duracaoController.text,
                                  items: ['30', '60', '90', '120', '150', '180'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        duracaoController.text = newValue;
                                      });
                                    }
                                  },
                                  decoration: inputDecoration,
                                  validator: (v) => (v == null || v.isEmpty) ? 'Informe a duração' : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Valor (R\$)', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: valorController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: inputDecoration.copyWith(hintText: '100.00'),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return 'Informe o valor';
                                    if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Valor inválido';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Divider(),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Tags / Categorias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 15),
                          Text('Adicione até 3 tags', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_loadingTags)
                        const Center(child: CircularProgressIndicator())
                      else
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.add, color: Color.fromARGB(255, 156, 156, 156)),
                              label: const Text('Tag', style: TextStyle(color: Color.fromARGB(255, 34, 34, 34))),
                              backgroundColor: const Color.fromARGB(255, 117, 117, 117).withOpacity(0.1),
                              onPressed: _showAddTagDialog,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.transparent),
                              ),
                            ),
                            ...tagsSelecionadas.map((tagId) {
                              final tag = tagsDisponiveis.firstWhere((t) => t['id'] == tagId);
                              return Chip(
                                label: Text(tag['nome']),
                                backgroundColor: Colors.grey[200],
                                onDeleted: () => setState(() => tagsSelecionadas.remove(tagId)),
                                deleteIcon: const Icon(Icons.close, size: 18),
                              );
                            }).toList(),
                          ],
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Não achou sua tag? ', style: TextStyle(color: Colors.grey[600])),
                          InkWell(
                            onTap: () {
  final TextEditingController novaTagController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Nova Tag'),
        content: TextField(
          controller: novaTagController,
          decoration: const InputDecoration(
            labelText: 'Nome da nova tag',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nomeTag = novaTagController.text.trim();

              if (nomeTag.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('O nome da tag não pode ser vazio.')),
                );
                return;
              }

              final existe = tagsDisponiveis.any((tag) =>
                  (tag['nome'] as String).toLowerCase().trim() == nomeTag.toLowerCase());

              if (existe) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Essa tag já existe.')),
                );
                return;
              }

              Navigator.of(ctx).pop(); // fecha o dialog

              final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/tags');
              final body = jsonEncode({
                'nome': nomeTag,
                'status': 'Ativo',
              });

              try {
                final response = await http.post(
                  uri,
                  headers: {'Content-Type': 'application/json'},
                  body: body,
                );

                if (response.statusCode == 201 || response.statusCode == 200) {
                  final novaTag = jsonDecode(utf8.decode(response.bodyBytes));
                  setState(() {
                    tagsDisponiveis.add(novaTag);
                    if (tagsSelecionadas.length < 3) {
                      tagsSelecionadas.add(novaTag['id']);
                    }
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tag criada com sucesso!')),
                  );
                } else {
                  final msg = jsonDecode(response.body)['message'] ?? 'Erro ao criar tag.';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(msg)),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro de conexão: $e')),
                );
              }
            },
            child: const Text('Criar'),
          ),
        ],
      );
    },
  );
},
                            child: const Text(
                              'Crie uma nova',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
