import 'package:flutter/material.dart';
import 'package:quebragalho2/views/prestador/pages/detalhes_solicitacao.dart';
import 'package:quebragalho2/views/prestador/widgets/solicitacao_cliente_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> clientes = const [
    {'nome': 'João da Silva', 'foto': 'https://i.pravatar.cc/150?img=1'},
    {'nome': 'Maria Oliveira', 'foto': 'https://i.pravatar.cc/150?img=2'},
    {'nome': 'Carlos Pereira', 'foto': 'https://i.pravatar.cc/150?img=3'},
    {'nome': 'Ana Souza', 'foto': 'https://i.pravatar.cc/150?img=4'},
    // Pode colocar quantos quiser, fera
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Solicitações')),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          return SolicitacaoClienteCard(
            nome: cliente['nome']!,
            fotoUrl: cliente['foto']!,
            onTap: () {
              //Navegando para a página de detalhes da solicitação
              // Enviando os detalhes da solicitação para tela de solicitação
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => DetalhesSolicitacaoPage(
                        nome: cliente['nome']!,
                        fotoUrl: cliente['foto']!,
                        servico: 'Corte de Cabela',
                        dataHora: '09/05/2025 das 14:00 às 15:00',
                        valorTotal: 50,
                      ),
                ),
              );
              // Aqui você pode adicionar a lógica para navegar para a página de detalhes do cliente
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesClientePage(cliente: cliente)));
            },
          );
        },
      ),
    );
  }
}
