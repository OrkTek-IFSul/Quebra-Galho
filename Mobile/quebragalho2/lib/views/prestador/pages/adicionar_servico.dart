import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdicionarServico extends StatefulWidget {
  final int idPrestador; // Add this parameter

  const AdicionarServico({
    super.key,
    required this.idPrestador,
  });

  @override
  State<AdicionarServico> createState() => _AdicionarServicoState();
}

class _AdicionarServicoState extends State<AdicionarServico> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  bool _isLoading = false;

  Future<void> _salvarServico() async {
    final nome = nomeController.text.trim();
    final descricao = descricaoController.text.trim();
    final valor = int.tryParse(valorController.text.trim());

    if (nome.isEmpty || descricao.isEmpty || valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:8080/api/prestador/servico/${widget.idPrestador}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nome': nome,
          'descricao': descricao,
          'preco': valor,
          'prestador': {
            'id': widget.idPrestador,
          },
          'tags': []
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
        throw Exception('Falha ao adicionar serviço');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar serviço: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Serviço')),
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
    );
  }
}
