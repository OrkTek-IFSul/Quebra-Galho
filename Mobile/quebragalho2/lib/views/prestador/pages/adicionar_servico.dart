import 'package:flutter/material.dart';

// Tu pantalla principal, desde donde navegarás a AdicionarServicoScreen
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Ir a Adicionar Serviço'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdicionarServicoScreen()),
            );
          },
        ),
      ),
    );
  }
}

// Tu pantalla AdicionarServicoScreen 
class AdicionarServicoScreen extends StatefulWidget {
  const AdicionarServicoScreen({super.key});

  @override
  State<AdicionarServicoScreen> createState() => _AdicionarServicoScreenState();
}

class _AdicionarServicoScreenState extends State<AdicionarServicoScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  void _salvarServico() {
    final nome = nomeController.text.trim();
    final descricao = descricaoController.text.trim();
    final valor = int.tryParse(valorController.text.trim());

    if (nome.isEmpty || descricao.isEmpty || valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Serviço "$nome" adicionado com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    valorController.dispose();
    super.dispose();
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
              child: ElevatedButton(
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

void main() {
  runApp(const MaterialApp(home: PerfilPage()));
}
