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


// ============== SUBSTITUA SUA CLASSE STATE POR ESTA =================

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

  // NOVO: Adicionado para controlar o dropdown de duração.
  int _selectedDuration = 30; 
  // TODO: Você precisará integrar a lógica para salvar este valor de duração.

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

    // Aqui está o ajuste:
    final allowedDurations = [30, 60, 90, 120];
    _selectedDuration = allowedDurations.contains(widget.duracao) ? widget.duracao! : 30;

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
    // Sua lógica para carregar tags permanece a mesma...
    // (Omitido por brevidade, mantenha seu código original aqui)
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
    // Sua lógica de salvar serviço permanece a mesma.
    // Lembre-se de adicionar a variável `_selectedDuration` se precisar salvá-la.
    // (Omitido por brevidade, mantenha seu código original aqui)
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
  return {
    'id': tag['id'],
    'nome': tag['nome'],
  };
}).toList();

  final sucesso = await _servicoService.atualizarServico(
   idPrestador: _idPrestador!,
   idServico: _idServico!,
   nome: nome,
   descricao: descricao,
   duracao: duracao,
   valor: valor,
   tags: tagsJson, // Agora com id e nome
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

  // NOVO: Função auxiliar para estilizar os TextFields como na imagem
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  // NOVO: Função para exibir um diálogo para adicionar tags
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

  // ===================================================================
  // MÉTODO BUILD COMPLETAMENTE REFEITO PARA CORRESPONDER À IMAGEM
  // ===================================================================
  @override
  Widget build(BuildContext context) {
    if (_loadingIds || _loadingTags) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // --- AppBar modificada ---
      appBar: AppBar(
        // O ícone de voltar é adicionado automaticamente pelo Navigator
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Editar'), // Título como na imagem
        centerTitle: true,
        // Ícone de check para salvar
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                      width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2,)),
                )
              : IconButton(
                  icon: const Icon(Icons.check, size: 30),
                  onPressed: _salvarServico,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Campo Nome ---
            const Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: nomeController,
              decoration: _buildInputDecoration('Instalação de Ar-condicionado'),
            ),
            const SizedBox(height: 24),

            // --- Campo Descrição ---
            const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: descricaoController,
              maxLines: 4,
              decoration: _buildInputDecoration('(55) 55555-5555'),
            ),
            const SizedBox(height: 24),

            // --- Linha para Duração e Valor ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Coluna Duração ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Duração (Minutos)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      // Dropdown para duração
                      DropdownButtonFormField<int>(
                        value: _selectedDuration,
                        items: const [
                          DropdownMenuItem(value: 30, child: Text('30')),
                          DropdownMenuItem(value: 60, child: Text('60')),
                          DropdownMenuItem(value: 90, child: Text('90')),
                          DropdownMenuItem(value: 120, child: Text('120')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedDuration = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // --- Coluna Valor ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Valor (R\$)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: valorController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _buildInputDecoration('100.00'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Seção de Tags ---
            const Text('Tags / Categorias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text(
              'Adicione até 3 tags para seu perfil',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),
            
            // Widget Wrap para exibir as tags como chips
            Wrap(
              spacing: 8.0, // Espaço horizontal entre os chips
              runSpacing: 4.0, // Espaço vertical entre as linhas de chips
              children: [
                // Botão para adicionar nova tag
                ActionChip(
                  label: const Text('+ Tag'),
                  onPressed: _showAddTagDialog,
                  backgroundColor: Colors.grey[200],
                ),
                // Mapeia as tags selecionadas para Chips
                ...tagsSelecionadas.map((tagId) {
                  final tag = tagsDisponiveis.firstWhere(
                    (t) => t['id'] == tagId,
                    orElse: () => {'id': tagId, 'nome': 'Carregando...'},
                  );
                  return Chip(
                    label: Text(tag['nome']),
                    backgroundColor: Colors.grey[300],
                    onDeleted: () {
                      setState(() {
                        tagsSelecionadas.remove(tagId);
                      });
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // --- Link para criar nova tag ---
            Row(
              children: [
                const Text('Não achou sua tag? '),
                InkWell(
                  onTap: () {
                    // TODO: Implementar a navegação ou modal para criar uma nova tag
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
    );
  }
}