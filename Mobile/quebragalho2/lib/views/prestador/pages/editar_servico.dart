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
  int _selectedDuration = 30;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nomeInicial);
    descricaoController = TextEditingController(text: widget.descricaoInicial);
    valorController = TextEditingController(text: widget.valorInicial.toStringAsFixed(2));

    _idPrestador = widget.idPrestador;
    _idServico = widget.idServico;

    if (widget.tagsServico != null) {
      tagsSelecionadas.addAll(widget.tagsServico!);
    }

    final allowedDurations = [30, 60, 90, 120];
    _selectedDuration = allowedDurations.contains(widget.duracao) ? widget.duracao! : 30;

    if (_idPrestador == null) _loadIds();
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

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintText: hint,
      counterText: '', // remove contador de caracteres visível
    );
  }

  void _showAddTagDialog() {
    final tagsParaAdicionar = tagsDisponiveis
        .where((tag) => !tagsSelecionadas.contains(tag['id']))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecione uma Tag'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tagsParaAdicionar.length,
              itemBuilder: (context, index) {
                final tag = tagsParaAdicionar[index];
                return ListTile(
                  title: Text(tag['nome']),
                  onTap: () {
                    setState(() {
                      tagsSelecionadas.add(tag['id']);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _salvarServico() async {
    if (!_formKey.currentState!.validate()) return;

    final nome = nomeController.text.trim();
    final descricao = descricaoController.text.trim();
    final valorText = valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorText);
    final duracao = _selectedDuration;

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

    final tagsJson = tagsSelecionadas.map((id) {
      final tag = tagsDisponiveis.firstWhere((t) => t['id'] == id);
      return {'id': tag['id'], 'nome': tag['nome']};
    }).toList();

    final sucesso = await _servicoService.atualizarServico(
      idPrestador: _idPrestador!,
      idServico: _idServico!,
      nome: nome,
      descricao: descricao,
      duracao: duracao,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Editar'),
        centerTitle: true,
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                      width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : IconButton(
                  icon: const Icon(Icons.check, size: 30),
                  onPressed: _salvarServico,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: nomeController,
                maxLength: 45,
                decoration: _buildInputDecoration('Nome do serviço'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o nome';
                  if (v.trim().length > 45) return 'Máximo de 45 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: descricaoController,
                maxLength: 45,
                maxLines: 2,
                decoration: _buildInputDecoration('Descrição do serviço'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe a descrição';
                  if (v.trim().length > 45) return 'Máximo de 45 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Duração (Min)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedDuration,
                          items: const [
                            DropdownMenuItem(value: 30, child: Text('30')),
                            DropdownMenuItem(value: 60, child: Text('60')),
                            DropdownMenuItem(value: 90, child: Text('90')),
                            DropdownMenuItem(value: 120, child: Text('120')),
                          ],
                          onChanged: (v) => setState(() => _selectedDuration = v!),
                          decoration: _buildInputDecoration(''),
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
                          decoration: _buildInputDecoration('100.00'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Informe o valor';
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

              const Text('Tags / Categorias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text('Adicione até 3 tags', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  ActionChip(
                    label: const Text('+ Tag'),
                    onPressed: _showAddTagDialog,
                    backgroundColor: Colors.grey[200],
                  ),
                  ...tagsSelecionadas.map((tagId) {
                    final tag = tagsDisponiveis.firstWhere(
                      (t) => t['id'] == tagId,
                      orElse: () => {'id': tagId, 'nome': 'Carregando...'},
                    );
                    return Chip(
                      label: Text(tag['nome']),
                      backgroundColor: Colors.grey[300],
                      onDeleted: () => setState(() => tagsSelecionadas.remove(tagId)),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Não achou sua tag? '),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidade "Criar nova tag" a ser implementada.')),
                      );
                    },
                    child: const Text(
                      'Crie uma nova',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
