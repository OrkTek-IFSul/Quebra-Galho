import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/api_config.dart';

class DetalhesPrestadorPage extends StatefulWidget {
  final int idPrestador;

  const DetalhesPrestadorPage({super.key, required this.idPrestador});

  @override
  State<DetalhesPrestadorPage> createState() => _DetalhesPrestadorPageState();
}

class _DetalhesPrestadorPageState extends State<DetalhesPrestadorPage> {
  Map<String, dynamic>? prestador;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrestadorDetalhado();
  }

  Future<void> fetchPrestadorDetalhado() async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/analisarPrestador/${widget.idPrestador}',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        setState(() {
          prestador = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar dados');
      }
    } catch (e) {
      print('Erro: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _enviarAcao(String tipo) async {
    final uri = Uri.parse(
      'https://${ApiConfig.baseUrl}/api/moderacao/analisarPrestador/${tipo}Prestador/${widget.idPrestador}',
    );

    try {
      final response = await http.put(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Prestador ${tipo == 'aceitar' ? 'aceito' : 'recusado'} com sucesso.',
            ),
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Erro ao ${tipo} prestador');
      }
    } catch (e) {
      print('Erro ao ${tipo} prestador: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Prestador")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : prestador == null
              ? const Center(child: Text("Erro ao carregar dados"))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Text(
                      'Descrição:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(prestador!['descricao'] ?? '---'),
                    const SizedBox(height: 16),

                    Text(
                      'Documento do Prestador:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Image.network(
                      'https://${ApiConfig.baseUrl}/${prestador!['imgDocumento']}',
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) => const Text("Erro ao carregar imagem"),
                    ),
                    const SizedBox(height: 16),

                    const Divider(),

                    Text(
                      'Nome:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(prestador!['usuario']?['nome'] ?? '---'),
                    const SizedBox(height: 8),

                    Text(
                      'Email:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(prestador!['usuario']?['email'] ?? '---'),
                    const SizedBox(height: 8),

                    Text(
                      'Telefone:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(prestador!['usuario']?['telefone'] ?? '---'),
                    const SizedBox(height: 8),

                    Text('CPF:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(prestador!['usuario']?['documento'] ?? '---'),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () => _enviarAcao('aceitar'),
                          icon: const Icon(Icons.check),
                          label: const Text("Aceitar"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => _enviarAcao('recusar'),
                          icon: const Icon(Icons.close),
                          label: const Text("Recusar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
