import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/adicionar_servico.dart';
import 'package:quebragalho2/views/prestador/pages/editar_servico.dart';
import 'package:quebragalho2/views/prestador/widgets/servico_card.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final List<Map<String, dynamic>> servicos = [
    {'nome': 'Corte Masculino', 'valor': 40.0},
    {'nome': 'Barba', 'valor': 25.0},
    {'nome': 'Sobrancelha', 'valor': 15.0},
  ];

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  void _mostrarModalAdicionarServico() {
    nomeController.clear();
    valorController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 24,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Adicionar novo serviço',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do serviço',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: valorController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final nome = nomeController.text;
                    final valor = double.tryParse(valorController.text);

                    if (nome.isNotEmpty && valor != null) {
                      setState(() {
                        servicos.add({'nome': nome, 'valor': valor});
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Adicionar'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔷 Header com imagem + nome + botão
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/300',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.edit, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paizão do Corte',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MeusDados(),
                            ),
                          );
                        },
                        child: const Text('Meus dados'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🔶 Título "Serviços" + botão "+ adicionar"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Serviços',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdicionarServico(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 🔽 Lista de serviços
            Expanded(
              child: ListView.builder(
                itemCount: servicos.length,
                itemBuilder: (context, index) {
                  final servico = servicos[index];
                  return ServicoCard(
                    nome: servico['nome'],
                    valor: servico['valor'],
                    onDelete: () {
                      setState(() {
                        servicos.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Serviço removido: ${servico['nome']}'),
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditarServico(
                                nomeInicial: servico['nome'],
                                descricaoInicial: 'Descrição padrão do serviço',
                                valorInicial: servico['valor'].toInt(),
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
