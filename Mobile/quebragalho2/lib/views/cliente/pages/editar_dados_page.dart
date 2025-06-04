import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';

class EditarDadosPage extends StatefulWidget {
  const EditarDadosPage({super.key});

  @override
  State<EditarDadosPage> createState() => _EditarDadosPageState();
}

class _EditarDadosPageState extends State<EditarDadosPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _cpf = '';

  final int idUsuario = 1; // Substitua pelo ID real

  @override
  void initState() {
    super.initState();
    fetchUsuario();
  }

  Future<void> fetchUsuario() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/usuario/perfil/$idUsuario'),
        // O endereço http://10.0.2.2:8080 funciona no Android Emulator. Para outros dispositivos, pode ser necessário ajustar.
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nomeController.text = data['nome'] ?? '';
          _telefoneController.text = data['telefone'] ?? '';
          _emailController.text = data['email'] ?? '';
          _cpf = data['documento'] ?? '';
        });
      } else {
        throw Exception('Erro ao buscar dados do usuário');
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar dados')));
    }
  }

  Future<void> salvarDados() async {
    try {
      final response = await http.put(
        Uri.parse(
          'http://10.0.2.2:8080/api/usuario/perfil/atualizar/$idUsuario',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': _nomeController.text,
          'telefone': _telefoneController.text,
          'email': _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Dados atualizados!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PerfilPage(),
          ), // Volta para a tela de perfil
        );
      } else {
        throw Exception('Erro ao atualizar dados');
      }
    } catch (e) {
      print('Erro ao atualizar dados: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao atualizar dados")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Dados"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => MaterialPageRoute(
                builder: (_) => PerfilPage(),
              ), // Volta para a tela de perfil
        ),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: salvarDados),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome completo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _telefoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
