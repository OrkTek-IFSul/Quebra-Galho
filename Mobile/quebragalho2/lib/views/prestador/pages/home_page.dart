import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quebragalho2/views/prestador/pages/detalhes_solicitacao.dart';
import 'package:quebragalho2/views/prestador/widgets/solicitacao_cliente_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Variaveis para listagem de solicitacoes
  List<dynamic> solicitacoes = [];
  bool isLoading = true;

  //inicializar estado e executar carregamento do JSON
  @override
  void initState() {
    super.initState();
    fetchSolicitacoes();
  }

  //Método para carregar dados da API JSON
  Future<void> fetchSolicitacoes() async {
    try {
      final response = await http.get(
        // Modifique a URL para buscar todas as solicitações, incluindo as confirmadas
        Uri.parse('http://192.168.0.155:8080/api/prestador/pedidoservico/2'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          solicitacoes = data;
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar solicitações');
      }
    } catch (e) {
      print('Erro ao carregar solicitações: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Solicitações')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: solicitacoes.length,
                itemBuilder: (context, index) {
                  final solicitacao = solicitacoes[index];

                  // Formatar a data e hora
                  final DateTime dataHora = DateTime.parse(
                    solicitacao['dataHoraAgendamento'],
                  );
                  final String dataHoraFormatada =
                      '${dataHora.day}/${dataHora.month}/${dataHora.year} das ${dataHora.hour}:${dataHora.minute.toString().padLeft(2, '0')}';

                  return SolicitacaoClienteCard(
                    nome: solicitacao['nomeDoUsuario'],
                    fotoUrl:
                        'http://192.168.0.155:8080${solicitacao['fotoPerfilUsuario']}',
                    idAgendamento: solicitacao['idAgendamento'],
                    isConfirmed: solicitacao['statusPedidoAgendamento'] == true,
                    onConfirm: () {
                      // Apenas atualiza a lista para refletir a mudança de status
                      fetchSolicitacoes();
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetalhesSolicitacaoPage(
                                nome: solicitacao['nomeDoUsuario'],
                                fotoUrl:
                                    'http://192.168.0.155:8080${solicitacao['fotoPerfilUsuario']}',
                                servico: solicitacao['nomeServico'],
                                dataHora: dataHoraFormatada,
                                valorTotal:
                                    solicitacao['precoServico'].toDouble(),
                                idAgendamento: solicitacao['idAgendamento'],
                              ),
                        ),
                      ).then((_) {
                       
                          fetchSolicitacoes();
                        
                      });
                    },
                  );
                },
              ),
    );
  }
}
