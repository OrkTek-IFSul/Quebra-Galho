import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  List<String> tags = [];
  String? horaInicioSelecionada;
  String? horaFimSelecionada;

  bool isLoading = true;
  int? idUsuario;
  int? idPrestador;

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar() async {
    final id = await obterIdUsuario();
    if (id == null) {
      setState(() => isLoading = false);
      return;
    }

    setState(() {
      idUsuario = id;
      idPrestador = id;
    });

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
      final tagPrestadorResp = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/tag-prestador/prestador/$idPrestador'),
      );

      if (usuarioResp.statusCode == 200 &&
          prestadorResp.statusCode == 200 &&
          tagPrestadorResp.statusCode == 200) {
        final usuario = jsonDecode(usuarioResp.body);
        final prestador = jsonDecode(prestadorResp.body);
        final List tagIds = jsonDecode(tagPrestadorResp.body);

        final List<String> tagNomes = [];

        for (var idTag in tagIds) {
          final tagResp = await http.get(
            Uri.parse('https://${ApiConfig.baseUrl}/api/tags/$idTag'),
          );

          if (tagResp.statusCode == 200) {
            final tagData = jsonDecode(tagResp.body);
            tagNomes.add(tagData['nome']);
          }
        }

        setState(() {
          nomeController.text = usuario['nome'];
          telefoneController.text = usuario['telefone'];
          emailController.text = usuario['email'];
          horaInicioSelecionada = prestador['data_hora_inicio'];
          horaFimSelecionada = prestador['data_hora_fim'];
          tags = tagNomes;
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

  void abrirModalAdicionarTag() {
    final TextEditingController novaTagController = TextEditingController();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                const Text('Adicionar nova tag',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Digite o nome da nova tag',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  controller: novaTagController,
                  decoration: const InputDecoration(labelText: 'Nova tag'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final novaTag = novaTagController.text.trim();
                    if (novaTag.isNotEmpty && !tags.contains(novaTag)) {
                      setState(() => tags.add(novaTag));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> salvarDados() async {
    if (idUsuario == null || idPrestador == null) return;

    final nome = nomeController.text.trim();
    final telefone = telefoneController.text.trim();
    final email = emailController.text.trim();

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

    try {
      await http.put(
        Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/$idUsuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nome': nome, 'telefone': telefone, 'email': email}),
      );

      await http.put(
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/$idPrestador'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data_hora_inicio': horaInicioSelecionada,
          'data_hora_fim': horaFimSelecionada
        }),
      );

      // Tags novas podem precisar de outro endpoint (POST para tag-prestador).
      // Você pode implementar essa lógica separadamente.

      if (mounted) {
        Navigator.pop(context); // Volta para a tela anterior
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
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 24),

            const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (int i = 0; i < tags.length; i++)
                  Chip(
                    label: Text(tags[i]),
                    onDeleted: () => setState(() => tags.removeAt(i)),
                  ),
                if (tags.length < 3)
                  ActionChip(
                    label: const Text('+ adicionar'),
                    onPressed: abrirModalAdicionarTag,
                  ),
              ],
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
                    onChanged: (value) {
                      setState(() {
                        horaInicioSelecionada = value;
                      });
                    },
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
                    onChanged: (value) {
                      setState(() {
                        horaFimSelecionada = value;
                      });
                    },
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
