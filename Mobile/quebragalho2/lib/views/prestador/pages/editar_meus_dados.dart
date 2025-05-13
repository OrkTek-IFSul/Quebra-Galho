import 'package:flutter/material.dart';

class EditarMeusDados extends StatefulWidget {
  const EditarMeusDados({super.key});

  @override
  State<EditarMeusDados> createState() => _EditarMeusDadosState();
}

class _EditarMeusDadosState extends State<EditarMeusDados> {
  final nomeController = TextEditingController(text: 'João da Silva');
  final telefoneController = TextEditingController(text: '(11) 91234-5678');
  final emailController = TextEditingController(text: 'joao@email.com');

  List<String> tags = ['Cabelo', 'Barba'];

  String? horaInicioSelecionada;
  String? horaFimSelecionada;

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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                const Text(
                  'Adicionar nova tag',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digite o nome da nova tag',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
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
                      setState(() {
                        tags.add(novaTag);
                      });
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

  @override
  Widget build(BuildContext context) {
    final opcoesHorario = gerarHorarios();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Meus Dados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (horaInicioSelecionada == null || horaFimSelecionada == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preencha os horários!')),
                );
                return;
              }
              if (_horaToInt(horaFimSelecionada!) <=
                  _horaToInt(horaInicioSelecionada!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Horário inválido')),
                );
                return;
              }

              // Salvar dados aqui...
            },
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

  int _horaToInt(String hora) {
    final partes = hora.split(':');
    return int.parse(partes[0]) * 60 + int.parse(partes[1]);
  }
}
