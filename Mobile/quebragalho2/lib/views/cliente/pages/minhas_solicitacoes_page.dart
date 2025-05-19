import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/detalhes_solicitacao_page.dart';
import 'package:quebragalho2/views/cliente/widgets/solicitacao_card.dart';

class MinhasSolicitacoesPage extends StatefulWidget {
  const MinhasSolicitacoesPage({super.key});

  @override
  State<MinhasSolicitacoesPage> createState() => _MinhasSolicitacoesPageState();
}

class _MinhasSolicitacoesPageState extends State<MinhasSolicitacoesPage> {
  final TextEditingController _searchController = TextEditingController();

  //LISTA DE DADOS PARA SIMULAÇÃO
  List<Map<String, String>> solicitacoes = [
    {
      'nome': 'Maria dos Anjos',
      'horario': '10:00 - 11:00',
      'status': 'Confirmado',
      'imagem': 'https://i.pravatar.cc/150?img=10', // só uma imagem fake
    },
    {
      'nome': 'João Mecânico',
      'horario': '14:00 - 15:00',
      'status': 'Pendente',
      'imagem': 'https://i.pravatar.cc/150?img=12',
    },
    {
      'nome': 'Cláudia Manicure',
      'horario': '16:00 - 17:00',
      'status': 'Cancelado',
      'imagem': 'https://i.pravatar.cc/150?img=18',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Solicitações")),
      body: Column(
        children: [
          /// Barra de Pesquisa
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // aqui daria pra filtrar a lista
                });
              },
            ),
          ),

          /// Lista de Prestadores
          Expanded(
            child: ListView.builder(
              itemCount: solicitacoes.length,
              itemBuilder: (context, index) {
                final item = solicitacoes[index];
                return SolicitacaoWidget(
                  nome: item['nome']!,
                  horario: item['horario']!,
                  status: item['status']!,
                  imagemUrl: item['imagem']!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => DetalhesSolicitacaoPage(
                              nome: "Fulano",
                              horario: "10h às 11h",
                              status: "Confirmado",
                              imagemUrl: "https://via.placeholder.com/150",
                              valor: "150.00",
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
    );
  }
}
