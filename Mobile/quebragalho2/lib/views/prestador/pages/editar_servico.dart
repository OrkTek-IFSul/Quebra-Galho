import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/services/editar_servico_services.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // para obterIdPrestador()

class EditarServico extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;
  final double valorInicial;
  final int? idPrestador;
  final int? idServico;
  final List<int>? tagsServico; // ← corrigido para refletir a origem real

  const EditarServico({
    super.key,
    required this.nomeInicial,
    required this.descricaoInicial,
    required this.valorInicial,
    this.idPrestador,
    this.idServico,
    this.tagsServico,
  });

  @override
  State<EditarServico> createState() => _EditarServicoState();
}

class _EditarServicoState extends State<EditarServico> {
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController valorController;

  bool _isSaving = false;
  final _servicoService = EditarServicoService();

  int? _idPrestador;
  int? _idServico;

  bool _loadingIds = false;
  bool _loadingTags = true;

  List<Map<String, dynamic>> tagsDisponiveis = [];
  final Set<int> tagsSelecionadas = {};

  int? _tagDropdownSelecionada;

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(text: widget.nomeInicial);
    descricaoController = TextEditingController(text: widget.descricaoInicial);
    valorController = TextEditingController(text: widget.valorInicial.toString());

    _idPrestador = widget.idPrestador;
    _idServico = widget.idServico;

    if (widget.tagsServico != null) {
      tagsSelecionadas.addAll(widget.tagsServico!);
    }

    if (_idPrestador == null) {
      _loadIds();
    }

    _carregarTags();
  }

  Future<void> _loadIds() async {
    setState(() => _loadingIds = true);
    final prestadorIdFromPrefs = await obterIdPrestador();
    setState(() {
      _idPrestador = prestadorIdFromPrefs;
      _loadingIds = false;
    });
  }

  Future<void> _carregarTags() async {
    final uri = Uri.http(ApiConfig.baseUrl, '/api/usuario/homepage/tags');
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

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    valorController.dispose();
    super.dispose();
  }

  Future<void> _salvarServico() async {
    final nome = nomeController.text.trim();
    final descricao = descricaoController.text.trim();
    final valorText = valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorText);

    if (valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor precisa ser um número válido')),
      );
      return;
    }

    if (_idPrestador == null || _idServico == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IDs necessários não disponíveis')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final tagsJson = tagsSelecionadas.map((id) => {'id': id}).toList();

    final sucesso = await _servicoService.atualizarServico(
      idPrestador: _idPrestador!,
      idServico: _idServico!,
      nome: nome,
      descricao: descricao,
      valor: valor,
      tags: tagsJson,
    );

    setState(() => _isSaving = false);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Serviço "$nome" salvo com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar serviço')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingIds || _loadingTags) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tagsParaAdicionar = tagsDisponiveis
        .where((tag) => !tagsSelecionadas.contains(tag['id']))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Valor: R\$'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: valorController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(hintText: 'Digite o valor, ex: 123.45'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Tags Selecionadas:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (tagsSelecionadas.isEmpty)
              const Text('Nenhuma tag selecionada.')
            else
              ...tagsSelecionadas.map((tagId) {
                final tag = tagsDisponiveis.firstWhere(
                  (t) => t['id'] == tagId,
                  orElse: () => {'nome': 'Tag desconhecida'},
                );
                return CheckboxListTile(
                  title: Text(tag['nome']),
                  value: true,
                  onChanged: (selected) {
                    if (selected == false) {
                      setState(() {
                        tagsSelecionadas.remove(tagId);
                      });
                    }
                  },
                );
              }).toList(),
            const SizedBox(height: 24),
            const Text('Adicionar tag:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              isExpanded: true,
              hint: const Text('Selecione uma tag para adicionar'),
              value: _tagDropdownSelecionada,
              items: tagsParaAdicionar.map((tag) {
                return DropdownMenuItem<int>(
                  value: tag['id'],
                  child: Text(tag['nome']),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    tagsSelecionadas.add(value);
                    _tagDropdownSelecionada = null;
                  });
                }
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _salvarServico,
                      child: const Text('Salvar'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
