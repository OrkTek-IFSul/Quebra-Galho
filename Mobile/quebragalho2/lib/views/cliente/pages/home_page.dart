import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
// Certifique-se de que os caminhos de importação estão corretos para o seu projeto
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
  final TextEditingController searchController = TextEditingController();
  List<dynamic> _prestadoresFiltrados = [];
  bool isLoading = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    searchController.addListener(_debouncedSearch);
  }

  void _debouncedSearch() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPrestadores();
    });
  }

  Future<void> _loadInitialData() async {
    // Mostra o loading ao iniciar
    setState(() {
      isLoading = true;
    });
    await fetchCategorias();
    await fetchPrestadores(); // Atualiza direto a lista e controla isLoading internamente
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

      // Se não houver texto de busca e nenhuma tag selecionada, busca todos os prestadores.
      // A verificação de queryParams.length == 2 (apenas 'page' e 'size')
      // cobre o caso de searchController.text estar vazio E selectedTags estar vazia.
      if (searchController.text.isEmpty && selectedTags.isEmpty) {
        return await fetchPrestadores(); // fetchPrestadores já lida com isLoading e setState
      }

      final uri = Uri.http(
        '192.168.0.155:8080', // Seu IP e porta
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
        print('Falha ao buscar prestadores: ${response.statusCode} ${response.body}');
        setState(() {
          _prestadoresFiltrados = []; // Limpa a lista em caso de erro
          isLoading = false;
        });
        // Lançar exceção pode ser útil se você tiver um Error Handler global
        // throw Exception('Falha ao buscar prestadores');
        return []; // Retorna lista vazia em caso de erro
      }
    } catch (e) {
      print('Erro na busca: $e');
      setState(() {
        _prestadoresFiltrados = []; // Limpa a lista em caso de erro
        isLoading = false;
      });
      // throw Exception('Erro na busca: $e');
      return []; // Retorna lista vazia em caso de erro
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_debouncedSearch); // Boa prática remover o listener
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCategorias() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.155:8080/api/usuario/homepage/tags'), // Seu IP e porta
      );

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
        // throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  Future<List<dynamic>> fetchPrestadores() async {
    // Esta função é chamada quando não há filtros (texto de busca ou tags)
    // ou na carga inicial.
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.155:8080/api/usuario/homepage'), // Seu IP e porta
      );

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
        // throw Exception('Falha ao carregar prestadores');
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
            // Se "Todos" estava selecionado e outra tag é selecionada,
            // não há necessidade de remover "Todos" explicitamente, pois selectedTags já estaria vazia
            // ou o comportamento de adicionar/remover a tag específica cuidará disso.
            if (selected) {
              selectedTags.add(category);
            } else {
              selectedTags.remove(category);
            }
          }
          // Sempre chame _searchPrestadores.
          // Esta função já lida com o caso de nenhum filtro estar ativo
          // (searchController.text.isEmpty && selectedTags.isEmpty)
          // chamando fetchPrestadores() internamente.
          _searchPrestadores();
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
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {
            // TODO: Implementar navegação ou ação para notificações
          }),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Verifique se LoginPage está corretamente importada e definida
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
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prestador...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Para um visual mais clean se preenchido
                ),
                filled: true, // Adicionar um preenchimento
                fillColor: Colors.grey[200], // Cor do preenchimento
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) =>
                    _buildCategoryChip(categories[index]),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _prestadoresFiltrados.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhum prestador encontrado.\nTente ajustar sua busca ou filtros.',
                            textAlign: TextAlign.center,
                          )
                        )
                      : ListView.builder(
                          itemCount: _prestadoresFiltrados.length,
                          itemBuilder: (context, index) {
                            final prestador = _prestadoresFiltrados[index];
                            // Validação defensiva para os dados do prestador
                            final String imageUrl = prestador['imagemPerfil'] as String? ?? ''; // Exemplo de como garantir string
                            final String nome = prestador['nome'] as String? ?? 'Nome Indisponível';
                            final List<String> tags = (prestador['tags'] as List?)
                                    ?.map((tag) => (tag is Map && tag['nome'] != null) ? tag['nome'].toString() : '')
                                    .where((tagNome) => tagNome.isNotEmpty) // Remove tags vazias se houver erro no map
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
                                          PrestadorDetalhesPage(id: prestadorId), // Verifique se PrestadorDetalhesPage está ok
                                    ),
                                  );
                                } else {
                                  // Opcional: mostrar um snackbar ou log se o ID for nulo
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('ID do prestador indisponível.'))
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