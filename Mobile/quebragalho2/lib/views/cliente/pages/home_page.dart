import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quebragalho2/views/cliente/pages/login_page.dart';

import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/prestador_home_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoggedIn = false;
  Timer? _debounce;

  int? usuarioId;

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
    _loadInitialData();
    searchController.addListener(_debouncedSearch);
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
    await prefs.clear(); // Limpa todos os dados de autenticação
    
    if (!mounted) return;
    
    // Navega para LoginPage e remove todas as rotas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout realizado com sucesso')),
    );
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
    setState(() {
      isLoading = true;
    });
    await fetchCategorias();
    await fetchPrestadores();

  }

  Future<List<dynamic>> _searchPrestadores() async {
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

      if (queryParams.length == 2) {
        return await fetchPrestadores();
      }

      if (searchController.text.isEmpty && selectedTags.isEmpty) {
        return await fetchPrestadores();
      }


     final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/buscar')
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
        print('Falha ao buscar prestadores: ${response.statusCode} ${response.body}');
        setState(() {
          _prestadoresFiltrados = [];
          isLoading = false;
        });
        return [];
      }
    } catch (e) {
      print('Erro na busca: $e');
      setState(() {
        _prestadoresFiltrados = [];
        isLoading = false;
      });
      return [];
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_debouncedSearch);
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCategorias() async {
    try {

      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/tags');
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
        print('Falha ao carregar categorias: ${response.statusCode} ${response.body}');
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

      final uri = Uri.parse('https://${ApiConfig.baseUrl}/api/usuario/homepage/prestadores');
      final response = await http.get(uri);


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _prestadoresFiltrados = data;
          isLoading = false;
        });
        return data;
      } else {
        print('Falha ao carregar prestadores: ${response.statusCode} ${response.body}');
        setState(() {
          _prestadoresFiltrados = [];
          isLoading = false;
        });
        return [];
      }
    } catch (e) {
      print('Erro ao carregar prestadores: $e');
      setState(() {
        _prestadoresFiltrados = [];
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
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (category == 'Todos') {
            selectedTags.clear();
          } else {
            if (selected) {
              selectedTags.add(category);
            } else {
              selectedTags.remove(category);
            }
          }
          _searchPrestadores();
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
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
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
                      ? const Center(
                          child: Text(
                            'Nenhum prestador encontrado.\nTente ajustar sua busca ou filtros.',
                            textAlign: TextAlign.center,
                          )
                        )

                      : ListView.builder(
                          itemCount: _prestadoresFiltrados.length,
                          itemBuilder: (context, index) {
                            final prestador = _prestadoresFiltrados[index];
                            final String imageUrl = prestador['imagemPerfil'] as String? ?? '';
                            final String nome = prestador['nome'] as String? ?? 'Nome Indisponível';
                            final List<String> tags = (prestador['tags'] as List?)
                                    ?.map((tag) => (tag is Map && tag['nome'] != null) ? tag['nome'].toString() : '')
                                    .where((tagNome) => tagNome.isNotEmpty)
                                    .toList() ??
                                [];
                            final double rating = (prestador['mediaAvaliacoes'] as num?)?.toDouble() ?? 0.0;
                            final int? prestadorId = prestador['id'] as int?;
                            return PrestadorHomeCard(
                              imageUrl: imageUrl,
                              name: nome,
                              categories: tags,
                              rating: rating,
                              onTap: () {
                                if (prestadorId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrestadorDetalhesPage(id: prestadorId),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('ID do prestador indisponível.'))
                                  );
                                }
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