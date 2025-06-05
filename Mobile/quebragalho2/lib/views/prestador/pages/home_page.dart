import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // Para obterIdPrestador()
import 'package:quebragalho2/views/prestador/pages/detalhes_solicitacao.dart';
import 'package:quebragalho2/views/prestador/widgets/solicitacao_cliente_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> solicitacoes = [];
  bool isLoading = true;
  int? idPrestador;

  @override
  void initState() {
    super.initState();
    carregarSolicitacoesDoPrestador();
  }

  Future<void> carregarSolicitacoesDoPrestador() async {
    final id = await obterIdPrestador();

    if (id != null) {
      setState(() {
        idPrestador = id;
      });
      fetchSolicitacoes(id);
    } else {
      setState(() {
        isLoading = false;
      });
      print('ID do prestador não encontrado.');
    }
  }

  Future<void> fetchSolicitacoes(int idPrestador) async {
    try {
      final response = await http.get(
        Uri.parse('https://${ApiConfig.baseUrl}/api/prestador/pedidoservico/$idPrestador'),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: solicitacoes.length,
              itemBuilder: (context, index) {
                final solicitacao = solicitacoes[index];

                final DateTime dataHora = DateTime.parse(
                  solicitacao['dataHoraAgendamento'],
                );
                final String dataHoraFormatada =
                    '${dataHora.day}/${dataHora.month}/${dataHora.year} às ${dataHora.hour}:${dataHora.minute.toString().padLeft(2, '0')}';

                return SolicitacaoClienteCard(
                  nome: solicitacao['nomeDoUsuario'],
                  fotoUrl:
                      'https://${ApiConfig.baseUrl}/${solicitacao['fotoPerfilUsuario']}',
                  idAgendamento: solicitacao['idAgendamento'],
                  isConfirmed: solicitacao['statusPedidoAgendamento'] == true,
                  isCanceled: solicitacao['statusPedidoAgendamento'] == false,
                  onConfirm: () {
                    if (idPrestador != null) {
                      fetchSolicitacoes(idPrestador!);
                    }
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhesSolicitacaoPage(
                          nome: solicitacao['nomeDoUsuario'],
                          fotoUrl:
                              'https://${ApiConfig.baseUrl}/${solicitacao['fotoPerfilUsuario']}',
                          servico: solicitacao['nomeServico'],
                          dataHora: dataHoraFormatada,
                          valorTotal: solicitacao['precoServico'].toDouble(),
                          idAgendamento: solicitacao['idAgendamento'],
                        ),
                      ),
                    ).then((_) {
                      if (idPrestador != null) {
                        fetchSolicitacoes(idPrestador!);
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
