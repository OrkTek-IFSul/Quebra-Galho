import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

class EditarMeusDados extends StatefulWidget {
  final String nome;
  final String telefone;
  final String email;
  final String documento;
  final String descricao;
  final String? horarioInicio; // ISO string ou null
  final String? horarioFim;    // ISO string ou null

  const EditarMeusDados({
    super.key,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.documento,
    required this.descricao,
    this.horarioInicio,
    this.horarioFim,
  });

  @override
  State<EditarMeusDados> createState() => _EditarMeusDadosState();
}

class _EditarMeusDadosState extends State<EditarMeusDados> {
  late TextEditingController nomeController;
  late TextEditingController telefoneController;
  late TextEditingController emailController;
  late TextEditingController descricaoController;
  late TextEditingController documentoController;

  String? horaInicioSelecionada;
  String? horaFimSelecionada;

  bool isLoading = false;
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

    nomeController = TextEditingController(text: widget.nome);
    telefoneController = TextEditingController(text: widget.telefone);
    emailController = TextEditingController(text: widget.email);
    descricaoController = TextEditingController(text: widget.descricao);
    documentoController = TextEditingController(text: widget.documento);

    // Preenche os horários com a parte "HH:mm" se existir
    if (widget.horarioInicio != null) {
      try {
        horaInicioSelecionada = widget.horarioInicio!.substring(11, 16);
      } catch (_) {
        horaInicioSelecionada = null;
      }
    }
    if (widget.horarioFim != null) {
      try {
        horaFimSelecionada = widget.horarioFim!.substring(11, 16);
      } catch (_) {
        horaFimSelecionada = null;
      }
    }

    carregarIds();
  }

  Future<void> carregarIds() async {
    final id = await obterIdUsuario();
    final idP = await obterIdPrestador();
    if (mounted) {
      setState(() {
        idUsuario = id;
        idPrestador = idP;
      });
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

  int _horaToInt(String hora) {
    final partes = hora.split(':');
    return int.parse(partes[0]) * 60 + int.parse(partes[1]);
  }

  Future<void> salvarDados() async {
    if (idUsuario == null || idPrestador == null) return;

    final nome = nomeController.text.trim();
    final telefone = telefoneMask.getUnmaskedText();
    final email = emailController.text.trim();
    final documento = documentoMask.getUnmaskedText();
    final descricao = descricaoController.text.trim();

    if (horaInicioSelecionada == null || horaFimSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os horários!')),
      );
      return;
    }
    if (_horaToInt(horaFimSelecionada!) <= _horaToInt(horaInicioSelecionada!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O horário de fim deve ser maior que o de início.')),
      );
      return;
    }

    try {
      await http.put(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'telefone': telefone, 'email': email}),
      );

      final horarioInicio = '2025-06-17T$horaInicioSelecionada:00'; // completando segundos
      final horarioFim = '2025-06-17T$horaFimSelecionada:00';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar dados.')),
      );
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
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

  @override
  Widget build(BuildContext context) {
    final opcoesHorario = gerarHorarios();

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
            buildTextField(
              label: 'Telefone',
              controller: telefoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [telefoneMask],
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text('Documento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    const SizedBox(height: 8),
    TextField(
      controller: documentoController,
      readOnly: true,
      keyboardType: TextInputType.number,
      inputFormatters: [documentoMask],
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
),

            const SizedBox(height: 20),
            buildTextField(label: 'Descrição', controller: descricaoController),
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
