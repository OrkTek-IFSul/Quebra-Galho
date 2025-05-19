import 'package:flutter/material.dart';

class EditarDadosPage extends StatefulWidget {
  const EditarDadosPage({super.key});

  @override
  State<EditarDadosPage> createState() => _EditarDadosPageState();
}

class _EditarDadosPageState extends State<EditarDadosPage> {
  final TextEditingController _nomeController = TextEditingController(text: "João da Silva");
  final TextEditingController _telefoneController = TextEditingController(text: "(11) 91234-5678");
  final TextEditingController _emailController = TextEditingController(text: "joao@gmail.com");

  final String _cpf = "123.456.789-00"; // CPF fixo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Dados"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Aqui você pode salvar os dados
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Dados atualizados!")),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            /// Nome
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome completo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Telefone
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// CPF fixo
            TextField(
              controller: TextEditingController(text: _cpf),
              enabled: false,
              decoration: const InputDecoration(
                labelText: "CPF",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
