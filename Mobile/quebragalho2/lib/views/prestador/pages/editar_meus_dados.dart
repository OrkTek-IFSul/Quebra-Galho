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
    final usuarioId = await obterIdUsuario();
    final prestadorId = await obterIdPrestador();

    if (usuarioId == null || prestadorId == null) {
      setState(() => isLoading = false);
      return;
    }

    idUsuario = usuarioId;
    idPrestador = prestadorId;

    await carregarDados();
  }

  Future<void> carregarDados() async {
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

        setState(() {
          nomeController.text = usuario['nome'];
          telefoneController.text = telefoneMask.maskText(usuario['telefone']);
          emailController.text = usuario['email'];
          documentoController.text = documentoMask.maskText(usuario['documento']);
          descricaoController.text = prestador['descricao'] ?? '';
          horaInicioSelecionada =
              prestador['horarioInicio']?.toString().substring(11, 16);
          horaFimSelecionada =
              prestador['horarioFim']?.toString().substring(11, 16);
          isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar dados do backend.');
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
      setState(() => isLoading = false);
    }
  }

  List<String> gerarHorarios() {
    List<String> lista = [];
    TimeOfDay hora = const TimeOfDay(hour: 8, minute: 0);

    while (hora.hour < 22 || (hora.hour == 22 && hora.minute == 0)) {
      final horaFormatada =
          '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
      lista.add(horaFormatada);

      final novoMinuto = hora.minute + 30;
      if (novoMinuto >= 60) {
        hora = TimeOfDay(hour: hora.hour + 1, minute: 0);
      } else {
        hora = TimeOfDay(hour: hora.hour, minute: novoMinuto);
      }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os horários!')),
      );
      return;
    }

    if (_horaToInt(horaFimSelecionada!) <= _horaToInt(horaInicioSelecionada!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horário inválido')),
      );
      return;
    }

    final horarioInicio = '2025-06-17T$horaInicioSelecionada';
    final horarioFim = '2025-06-17T$horaFimSelecionada';

    try {
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

      if (mounted) {
        Navigator.pop(context);
      }
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

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Meus Dados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: salvarDados,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.number,
              inputFormatters: [telefoneMask],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: documentoController,
              decoration: const InputDecoration(labelText: 'Documento'),
              keyboardType: TextInputType.number,
              inputFormatters: [documentoMask],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição do serviço'),
            ),
            const SizedBox(height: 24),
            const Text('Horário Disponível',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Início'),
                    value: horaInicioSelecionada,
                    items: opcoesHorario
                        .map((h) => DropdownMenuItem(
                              value: h,
                              child: Text(h),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => horaInicioSelecionada = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Fim'),
                    value: horaFimSelecionada,
                    items: opcoesHorario
                        .map((h) => DropdownMenuItem(
                              value: h,
                              child: Text(h),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => horaFimSelecionada = value),
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
