import 'package:flutter/material.dart';

class EditarServico extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;
  final int valorInicial;

  const EditarServico({
    super.key,
    required this.nomeInicial,
    required this.descricaoInicial,
    required this.valorInicial,
  });

  @override
  State<EditarServico> createState() => _EditarServicoState();
}

class _EditarServicoState extends State<EditarServico> {
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController valorController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nomeInicial);
    descricaoController = TextEditingController(text: widget.descricaoInicial);
    valorController = TextEditingController(text: widget.valorInicial.toString());
  }
 
  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    valorController.dispose();
    super.dispose();
  }

  void _salvarServico() {
    final nome = nomeController.text;
    final descricao = descricaoController.text;
    final valor = int.tryParse(valorController.text);

    if (valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor precisa ser um número inteiro')),
      );
      return;
    }

    // Aqui você pode salvar no backend ou setState em outra tela
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Serviço "$nome" salvo com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Somente números inteiros',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
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
