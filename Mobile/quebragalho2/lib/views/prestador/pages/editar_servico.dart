import 'package:flutter/material.dart';
import 'package:quebragalho2/services/editar_servico_services.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // para obterIdPrestador()

class EditarServico extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;
  final double valorInicial; // mudou para double
  final int? idPrestador;
  final int? idServico;

  const EditarServico({
    super.key,
    required this.nomeInicial,
    required this.descricaoInicial,
    required this.valorInicial,
    this.idPrestador,
    this.idServico,
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

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nomeInicial);
    descricaoController = TextEditingController(text: widget.descricaoInicial);
    valorController = TextEditingController(text: widget.valorInicial.toString());

    _idPrestador = widget.idPrestador;
    _idServico = widget.idServico;

    if (_idPrestador == null) {
      _loadIds();
    }
  }

  Future<void> _loadIds() async {
    setState(() {
      _loadingIds = true;
    });

    final prestadorIdFromPrefs = await obterIdPrestador();

    setState(() {
      _idPrestador = prestadorIdFromPrefs;
      _loadingIds = false;
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    valorController.dispose();
    super.dispose();
  }

  Future<void> _salvarServico() async {
    final nome = nomeController.text;
    final descricao = descricaoController.text;
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

    final sucesso = await _servicoService.atualizarServico(
      idPrestador: _idPrestador!,
      idServico: _idServico!,
      nome: nome,
      descricao: descricao,
      valor: valor,  // valor agora é double
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
    if (_loadingIds) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    decoration: const InputDecoration(
                      hintText: 'Digite o valor, ex: 123.45',
                    ),
                  ),
                ),
              ],
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
