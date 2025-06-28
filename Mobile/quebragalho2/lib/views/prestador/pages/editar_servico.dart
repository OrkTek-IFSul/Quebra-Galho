// editar_servico.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class EditarServico extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;
  final double valorInicial;
  final int? idPrestador;
  final int? idServico;
  final int? duracao;
  final List<int>? tagsServico;

  const EditarServico({
    super.key,
    required this.nomeInicial,
    required this.descricaoInicial,
    required this.valorInicial,
    required this.duracao,
    this.idPrestador,
    this.idServico,
    this.tagsServico,
  });

  @override
  State<EditarServico> createState() => _EditarServicoState();
}

class _EditarServicoState extends State<EditarServico> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  int _selectedDuration = 30;

  List<Map<String, dynamic>> tagsDisponiveis = [];
  final Set<int> tagsSelecionadas = {};
  bool _isLoading = false;
  int? _idPrestador;
  int? _idServico;

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.nomeInicial;
    descricaoController.text = widget.descricaoInicial;
    valorController.text = widget.valorInicial.toStringAsFixed(2);
    _selectedDuration = widget.duracao ?? 30;
    _idPrestador = widget.idPrestador;
    _idServico = widget.idServico;
    if (widget.tagsServico != null) {
      tagsSelecionadas.addAll(widget.tagsServico!);
    }

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
        });
      }
    } catch (_) {}
  }

  Future<void> _salvarServico() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idPrestador == null || _idServico == null) return;

    final body = jsonEncode({
      'nome': nomeController.text.trim(),
      'descricao': descricaoController.text.trim(),
      'preco': double.parse(valorController.text.replaceAll(',', '.')),
      'duracaoMinutos': _selectedDuration,
      'tags': tagsSelecionadas.map((id) {
        final tag = tagsDisponiveis.firstWhere((t) => t['id'] == id);
        return {'id': tag['id'], 'nome': tag['nome']};
      }).toList(),
    });

    setState(() => _isLoading = true);
    final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/servico/${_idPrestador!}/${_idServico!}');
    try {
      final res = await http.put(uri, headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200) {
        if (mounted) Navigator.pop(context, true);
      } else {
        _mostrarSnack('Erro ao salvar (status ${res.statusCode})');
      }
    } catch (e) {
      _mostrarSnack('Erro: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _adicionarTagDialog() {
    final restantes = tagsDisponiveis.where((t) => !tagsSelecionadas.contains(t['id'])).toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adicionar Tag'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: restantes.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(restantes[i]['nome']),
              onTap: () {
                if (tagsSelecionadas.length >= 1) {
                  _mostrarSnack('Máximo de 1 tag');
                } else {
                  setState(() => tagsSelecionadas.add(restantes[i]['id']));
                }
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _criarNovaTagDialog() {
    final TextEditingController novaTagCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Criar nova Tag'),
        content: TextFormField(
          controller: novaTagCtrl,
          decoration: const InputDecoration(hintText: 'Ex: Eletricista'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final nomeTag = novaTagCtrl.text.trim();
              if (nomeTag.isEmpty) {
                _mostrarSnack('Nome da tag não pode ser vazio.');
                return;
              }
              if (tagsDisponiveis.any((t) => t['nome'].toLowerCase() == nomeTag.toLowerCase())) {
                _mostrarSnack('Essa tag já existe.');
                return;
              }

              final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/tags');
              final res = await http.post(
                uri,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'nome': nomeTag, 'status': 'Ativo'}),
              );

              if (res.statusCode == 201) {
                final novaTag = jsonDecode(res.body);
                setState(() {
                  tagsDisponiveis.add(novaTag);
                  tagsSelecionadas.add(novaTag['id']);
                });
                Navigator.pop(context);
              } else {
                _mostrarSnack('Erro ao criar tag (${res.statusCode})');
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Serviço'),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
                )
              : IconButton(onPressed: _salvarServico, icon: const Icon(Icons.check)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                maxLength: 45,
                validator: (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 2,
                maxLength: 250,
                validator: (v) => v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedDuration,
                items: const [30, 60, 90, 120, 150, 180]
                    .map((d) => DropdownMenuItem(value: d, child: Text('$d minutos')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedDuration = v!),
                decoration: const InputDecoration(labelText: 'Duração'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: valorController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o valor';
                  if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text('Tags (máx 3)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    label: const Text('+ Tag'),
                    onPressed: _adicionarTagDialog,
                  ),
                  ...tagsSelecionadas.map((id) {
                    final tag = tagsDisponiveis.firstWhere((t) => t['id'] == id, orElse: () => {'nome': 'Indefinida'});
                    return Chip(
                      label: Text(tag['nome']),
                      onDeleted: () => setState(() => tagsSelecionadas.remove(id)),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Não achou sua tag?'),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: _criarNovaTagDialog,
                    child: const Text(
                      'Crie uma nova',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
