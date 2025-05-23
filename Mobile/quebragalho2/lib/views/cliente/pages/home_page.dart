import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quebragalho2/views/cliente/pages/login_page.dart';
import 'package:quebragalho2/views/cliente/pages/prestador_detalhes_page.dart';
import 'package:quebragalho2/views/cliente/widgets/prestador_home_card.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = ['Todos'];
  List<String> selectedTags = [];
  late Future<List<dynamic>> prestadoresFuture;
  final TextEditingController searchController = TextEditingController();
  List<dynamic> _prestadoresFiltrados = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    prestadoresFuture = fetchPrestadores();
    fetchCategorias();
    // Adiciona debounce na busca
    searchController.addListener(_debouncedSearch);
  }

  // Debounce para evitar múltiplas requisições
  Timer? _debounce;
 void _debouncedSearch() {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    // Sempre usa _searchPrestadores que agora vai lidar com ambos os filtros
    _searchPrestadores();
  });
}

// Função unificada para buscar prestadores com filtros
Future<List> _searchPrestadores() async {
  setState(() {
    isLoading = true;
  });

  try {
    // Constrói a query string com todos os filtros ativos
    final queryParams = {
      if (searchController.text.isNotEmpty) 'nome': searchController.text,
      if (selectedTags.isNotEmpty) 'tags': selectedTags.join(','),
      'page': '0',
      'size': '10',
    };

    // Se não houver filtros, carrega todos os prestadores
    if (queryParams.length == 2) { // Só tem page e size
      return await fetchPrestadores();
    }

    final uri = Uri.http(
      '192.168.0.155:8080',
      '/api/usuario/homepage/buscar',
      queryParams,
    );

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

  // Adicionar função para buscar categorias
  Future<void> fetchCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.155:8080/api/usuario/homepage/tags'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          // Manter 'Todos' como primeira opção e adicionar as demais categorias
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

  // Função para buscar os prestadores da API
  Future<List<dynamic>> fetchPrestadores() async {
  setState(() {
    isLoading = true;
  });

  try {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/usuario/homepage'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _prestadoresFiltrados = data;
        isLoading = false;
      });
      return data;
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Falha ao carregar prestadores');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    throw e;
  }
}
  // Nova função para filtrar apenas por tags
Future<void> _filterByTags() async {
  setState(() {
    isLoading = true;
  });

  try {
    // URL específica para filtrar por tags
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/usuario/homepage/tags/${selectedTags.join(",")}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _prestadoresFiltrados = data;
        isLoading = false;
      });
    } else {
      throw Exception('Falha ao filtrar por tags');
    }
  } catch (e) {
    
    setState(() {
      isLoading = false;
    });
  }
}

  // Modifique o onSelected do ChoiceChip
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
          fetchPrestadores();
        } else {
          if (selected) {
            selectedTags.add(category);
          } else {
            selectedTags.remove(category);
          }
          _searchPrestadores(); // Usa a busca unificada
        }
      });
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de pesquisa
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Filtros de categorias
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder:
                    (context, index) => _buildCategoryChip(categories[index]),
              ),
            ),
            SizedBox(height: 12),

            // Lista de prestadores
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _prestadoresFiltrados.isEmpty
                      ? Center(child: Text('Nenhum prestador encontrado'))
                      : ListView.builder(
                        itemCount: _prestadoresFiltrados.length,
                        itemBuilder: (context, index) {
                          final prestador = _prestadoresFiltrados[index];
                          List<String> tags =
                              (prestador['tags'] as List<dynamic>)
                                  .map((tag) => tag['nome'].toString())
                                  .toList();

                          return PrestadorHomeCard(
                            imageUrl: prestador['imagemPerfil'] ?? '',
                            name: prestador['nome'] ?? '',
                            categories: tags,
                            rating:
                                (prestador['mediaAvaliacoes'] ?? 0.0)
                                    .toDouble(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PrestadorDetalhesPage(
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
