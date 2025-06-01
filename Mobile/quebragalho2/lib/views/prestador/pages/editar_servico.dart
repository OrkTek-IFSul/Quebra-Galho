///
/// Perfil View - Quebra Galho App
/// By Jean Carlo | Orktek
/// github.com/jeankeitwo16
/// Descrição: Página de edição de serviços, onde o prestador pode atualizar os detalhes de um serviço específico, como nome, descrição e valor.
/// Versão: 1.0.0
///
import 'package:flutter/material.dart';
import 'package:quebragalho2/services/editar_servico_services.dart';

class EditarServico extends StatefulWidget {
  final String nomeInicial;
  final String descricaoInicial;
  final int valorInicial;
  //final int idPrestador;
  //final int idServico;

  const EditarServico({
    super.key,
    required this.nomeInicial,
    required this.descricaoInicial,
    required this.valorInicial,
    //required this.idPrestador,
    //required this.idServico,
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

  Future<void> _salvarServico() async {
    final nome = nomeController.text;
    final descricao = descricaoController.text;
    final valor = int.tryParse(valorController.text);

    if (valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor precisa ser um número inteiro')),
      );
      return;
    }

    setState(() => _isSaving = true);

    const idPrestador = 1; //tem que puxar da tela anterior depois, só pra teste
    const idServico = 1; //tem que puxar da tela anterior depois, só pra teste

    final sucesso = await _servicoService.atualizarServico(
      idPrestador: idPrestador,
      idServico: idServico,
      nome: nome,
      descricao: descricao,
      valor: valor,
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