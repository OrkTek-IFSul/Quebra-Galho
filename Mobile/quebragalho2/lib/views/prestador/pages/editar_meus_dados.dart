import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class EditarMeusDados extends StatefulWidget {
  const EditarMeusDados({super.key});

  @override
  State<EditarMeusDados> createState() => _EditarMeusDadosState();
}

class _EditarMeusDadosState extends State<EditarMeusDados> {
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final descricaoController = TextEditingController();
  final documentoController = TextEditingController();

  String? horaInicioSelecionada;
  String? horaFimSelecionada;

  bool isLoading = true;
  int? idUsuario;
  int? idPrestador;

  final telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'\d')});
  final documentoMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'\d')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar() async {
    final id = await obterIdUsuario();
    final idP = await obterIdPrestador();
    if (id == null || idP == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    if (mounted) {
      setState(() {
        idUsuario = id;
        idPrestador = idP;
      });
    }

    await carregarDados();
  }

  Future<void> carregarDados() async {
    if (idUsuario == null || idPrestador == null) return;

    try {
      final usuarioResp = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/perfil/$idUsuario'),
      );
      final prestadorResp = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/perfil/$idPrestador'),
      );

      if (usuarioResp.statusCode == 200 && prestadorResp.statusCode == 200) {
        final usuario = jsonDecode(usuarioResp.body);
        final prestador = jsonDecode(prestadorResp.body);

        if (mounted) {
          setState(() {
            nomeController.text = prestador['usuario']['nome'] ?? '';
            telefoneController.text = prestador['usuario']['telefone'] ?? '';
            emailController.text = prestador['usuario']['email'] ?? '';
            isLoading = false;
          });
        }

      } else {
        throw Exception('Erro ao carregar dados do backend.');
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  List<String> gerarHorarios() {
    List<String> lista = [];
    TimeOfDay hora = const TimeOfDay(hour: 8, minute: 0);

    while (hora.hour < 22 || (hora.hour == 22 && hora.minute == 0)) {
      final horaFormatada =
          '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
      lista.add(horaFormatada);
      int novoMinuto = hora.minute + 30;
      hora = TimeOfDay(
        hour: hora.hour + (novoMinuto >= 60 ? 1 : 0),
        minute: novoMinuto % 60,
      );
    }
    return lista;
  }

  Future<void> salvarDados() async {
    if (idUsuario == null || idPrestador == null) return;
    final nome = nomeController.text.trim();
    final telefone = telefoneMask.getUnmaskedText();
    final email = emailController.text.trim();
    final documento = documentoMask.getUnmaskedText();
    final descricao = descricaoController.text.trim();

    if (horaInicioSelecionada == null || horaFimSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha os horários!')));
      return;
    }
    if (_horaToInt(horaFimSelecionada!) <= _horaToInt(horaInicioSelecionada!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O horário de fim deve ser maior que o de início.')));
      return;
    }

    try {
      await http.put(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'telefone': telefone, 'email': email}),
      );

      final horarioInicio = '2025-06-17T$horaInicioSelecionada';
      final horarioFim = '2025-06-17T$horaFimSelecionada';

      final prestadorBody = jsonEncode({
        'descricao': descricao,
        'usuario': {
          'id': idUsuario,
          'nome': nome,
          'email': email,
          'telefone': telefone,
          'documento': documento,
        },
        'horarioInicio': horarioInicio,
        'horarioFim': horarioFim,
      });

      await http.put(
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/perfil/$idPrestador'),
        headers: {'Content-Type': 'application/json'},
        body: prestadorBody,
      );

      if (mounted) Navigator.pop(context, true);

    } catch (e) {
      debugPrint('Erro ao salvar dados: $e');
    }
  }

  int _horaToInt(String hora) {
    final partes = hora.split(':');
    return int.parse(partes[0]) * 60 + int.parse(partes[1]);
  }

  @override
  Widget build(BuildContext context) {
    final opcoesHorario = gerarHorarios();

    Widget buildTextField({
      required String label,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
    }

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar dados'), elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Editar dados'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Salvar',
            onPressed: salvarDados,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(label: 'Nome', controller: nomeController),
            const SizedBox(height: 20),
            buildTextField(label: 'Telefone', controller: telefoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            buildTextField(label: 'Email', controller: emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text('Horário de Atendimento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Início:', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: horaInicioSelecionada,
                        items: opcoesHorario.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                        onChanged: (value) => setState(() => horaInicioSelecionada = value),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fim:', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: horaFimSelecionada,
                        items: opcoesHorario.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                        onChanged: (value) => setState(() => horaFimSelecionada = value),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
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
