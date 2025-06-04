import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quebragalho2/views/prestador/pages/tela_perfil.dart';


class EditarDadosPage extends StatefulWidget {
  final int usuarioId;

  const EditarDadosPage({super.key, required this.usuarioId});

  @override
  State<EditarDadosPage> createState() => _EditarDadosPageState();
}

class _EditarDadosPageState extends State<EditarDadosPage> {


  final String _cpf = "123.456.789-00";

  Future<void> _atualizarDados() async {
    final url = Uri.parse(
      'https://seu-dominio.com/api/usuario/perfil/atualizar/${widget.usuarioId}',
    );

    final Map<String, dynamic> dados = {
      "id": widget.usuarioId,
      "nome": _nomeController.text,
      "email": _emailController.text,
      "telefone": _telefoneController.text,
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados atualizados com sucesso!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao atualizar: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro na requisição: $e")));
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
            builder: (_) => PerfilPage(idPrestador: 1,),
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
                builder: (_) => PerfilPage(idPrestador: 1,),
              ), // Volta para a tela de perfil
        ),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _atualizarDados),
          IconButton(icon: const Icon(Icons.check), onPressed: salvarDados),
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
