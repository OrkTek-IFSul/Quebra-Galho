import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:quebragalho2/views/cliente/pages/login_page.dart'; // onde está o obterIdUsuario()
import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/prestador_home_card.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'package:quebragalho2/api_config.dart'; // nova importação para a baseUrl

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ['Todos'];
  List<String> selectedTags = [];
  final TextEditingController searchController = TextEditingController();
  List<dynamic> _prestadoresFiltrados = [];
  bool isLoading = false;

  Timer? _debounce;

  int? usuarioId;

  @override
  void initState() {
    super.initState();
    carregarDados();
    searchController.addListener(_debouncedSearch);
  }

  Future<void> carregarDados() async {
    await carregarUsuarioId();
    await _loadInitialData();
  }

  Future<void> carregarUsuarioId() async {
    final id = await obterIdUsuario();
    setState(() {
      usuarioId = id;
    });
  }

  void _debouncedSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPrestadores();
    });
  }

  Future<void> _loadInitialData() async {
    await fetchCategorias();
    await fetchPrestadores();
  }

  Future<List> _searchPrestadores() async {
    setState(() {
      isLoading = true;
    });

    try {
      final queryParams = {
        if (searchController.text.isNotEmpty) 'nome': searchController.text,
        if (selectedTags.isNotEmpty) 'tags': selectedTags.join(','),
        'page': '0',
        'size': '10',
      };

      // Se só tem 'page' e 'size', chama fetchPrestadores direto
      if (queryParams.length == 2) {
        return await fetchPrestadores();
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/usuario/homepage/buscar')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _prestadoresFiltrados = data['content'] ?? [];
          isLoading = false;
        });
        return _prestadoresFiltrados;
      } else {
        throw Exception('Falha ao buscar prestadores');
      }
    } catch (e) {
      print('Erro na busca: $e');
      setState(() {
        isLoading = false;
      });
      throw Exception('Erro na busca: $e');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCategorias() async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/usuario/homepage/tags');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categories = [
            'Todos',
            ...data.map((tag) => tag['nome'].toString()),
          ];
        });
      } else {
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  Future<List<dynamic>> fetchPrestadores() async {
    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/usuario/homepage');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _prestadoresFiltrados = data;
          isLoading = false;
        });
        return data;
      } else {
        throw Exception('Falha ao carregar prestadores');
      }
    } catch (e) {
      print('Erro ao carregar prestadores: $e');
      setState(() {
        isLoading = false;
      });
      return [];
    }
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = category == 'Todos'
        ? selectedTags.isEmpty
        : selectedTags.contains(category);

    return ChoiceChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (category == 'Todos') {
            selectedTags.clear();
            if (searchController.text.isEmpty) {
              fetchPrestadores();
            } else {
              _searchPrestadores();
            }
          } else {
            if (selected) {
              selectedTags.add(category);
            } else {
              selectedTags.remove(category);
            }

            if (selectedTags.isEmpty) {
              if (searchController.text.isEmpty) {
                fetchPrestadores();
              } else {
                _searchPrestadores();
              }
            } else {
              _searchPrestadores();
            }
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('token_criado_em');
              await prefs.remove('manter_logado');

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) =>
                    _buildCategoryChip(categories[index]),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _prestadoresFiltrados.isEmpty
                      ? const Center(child: Text('Nenhum prestador encontrado'))
                      : ListView.builder(
                          itemCount: _prestadoresFiltrados.length,
                          itemBuilder: (context, index) {
                            final prestador = _prestadoresFiltrados[index];
                            List<String> tags = (prestador['tags'] as List)
                                .map((tag) => tag['nome'].toString())
                                .toList();

                            return PrestadorHomeCard(
                              imageUrl: prestador['imagemPerfil'] ?? '',
                              name: prestador['nome'] ?? '',
                              categories: tags,
                              rating: (prestador['mediaAvaliacoes'] ?? 0.0)
                                  .toDouble(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PrestadorDetalhesPage(
                                      id: prestador['id'],
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
