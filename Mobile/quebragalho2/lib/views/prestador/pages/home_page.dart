import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quebragalho2/api_config.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
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
  bool isLoggedIn = false;
  String? nomeUsuario;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadNomeUsuario();
    carregarSolicitacoesDoPrestador();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado com sucesso')),
    );
  }

  Future<void> _confirmLogout() async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação de Logout'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      _logout();
    }
  }

  Future<void> _loadNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nomeUsuario = prefs.getString('user_name') ?? '';
    });
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
      appBar: AppBar(
        title: isLoggedIn
            ? Text('Serviços', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
            : const Text('Solicitações'),
        actions: [
          if (isLoggedIn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                  color: Colors.black87,
                  splashRadius: 24,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
                tooltip: isLoggedIn ? 'Sair' : 'Entrar',
                onPressed: isLoggedIn
                    ? _confirmLogout
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        ),
                color: Colors.black87,
                splashRadius: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
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
                      'https://${ApiConfig.baseUrl}${solicitacao['fotoPerfilUsuario']}',
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
                              'https://${ApiConfig.baseUrl}${solicitacao['fotoPerfilUsuario']}',
                          servico: solicitacao['nomeServico'],
                          dataHora: dataHoraFormatada,
                          valorTotal: solicitacao['precoServico'].toDouble(),
                          idAgendamento: solicitacao['idAgendamento'],
                        ),
                      ),
                    ).then((_) {
          : RefreshIndicator(
              onRefresh: () async {
                await carregarSolicitacoesDoPrestador();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
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
                    fotoUrl: 'https://${ApiConfig.baseUrl}/${solicitacao['fotoPerfilUsuario']}',
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
                            fotoUrl: 'https://${ApiConfig.baseUrl}/${solicitacao['fotoPerfilUsuario']}',
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
            ),
    );
  }
}
